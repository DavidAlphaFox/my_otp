%%
%% %CopyrightBegin%
%%
%% Copyright Ericsson AB 1996-2011. All Rights Reserved.
%%
%% The contents of this file are subject to the Erlang Public License,
%% Version 1.1, (the "License"); you may not use this file except in
%% compliance with the License. You should have received a copy of the
%% Erlang Public License along with this software. If not, it can be
%% retrieved online at http://www.erlang.org/.
%%
%% Software distributed under the License is distributed on an "AS IS"
%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%% the License for the specific language governing rights and limitations
%% under the License.
%%
%% %CopyrightEnd%
%%

%%
-module(mnesia_bup).
-export([
         %% Public interface
         iterate/4,
         read_schema/2,
         fallback_bup/0,
         fallback_exists/0,
         tm_fallback_start/1,
         create_schema/1,
         install_fallback/1,
         install_fallback/2,
         uninstall_fallback/0,
         uninstall_fallback/1,
         traverse_backup/4,
         traverse_backup/6,
         make_initial_backup/3,
         fallback_to_schema/0,
         lookup_schema/2,
         schema2bup/1,
         refresh_cookie/2,

         %% Internal
         fallback_receiver/2,
         install_fallback_master/2,
         uninstall_fallback_master/2,
         local_uninstall_fallback/2,
         do_traverse_backup/7,
         trav_apply/4
        ]).

-include("mnesia.hrl").
-import(mnesia_lib, [verbose/2, dbg_out/2]).

-record(restore, {mode, bup_module, bup_data}).

-record(fallback_args, {opaque,
                        scope = global,
                        module = mnesia_monitor:get_env(backup_module),
                        use_default_dir = true,
                        mnesia_dir,
                        fallback_bup,
                        fallback_tmp,
                        skip_tables = [],
                        keep_tables = [],
                        default_op = keep_tables
                       }).

-type fallback_args() :: #fallback_args{}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Backup iterator

%% Reads schema section and iterates over all records in a backup.
%%
%% Fun(BunchOfRecords, Header, Schema, Acc) is applied when a suitable amount
%% of records has been collected.
%%
%% BunchOfRecords will be [] when the iteration is done.
%% 从backup文件进行数据恢复通用遍历函数
iterate(Mod, Fun, Opaque, Acc) ->
    R = #restore{bup_module = Mod, bup_data = Opaque},
    %% 读取元表
    case catch read_schema_section(R) of
        {error, Reason} ->
            {error, Reason};
        {R2, {Header, Schema, Rest}} ->
            case catch iter(R2, Header, Schema, Fun, Acc, Rest) of
                {ok, R3, Res} ->
                    %% 遍历整个备份文件成功了，关闭备份文件
                    catch safe_apply(R3, close_read, [R3#restore.bup_data]),
                    {ok, Res};
                {error, Reason} ->
                    catch safe_apply(R2, close_read, [R2#restore.bup_data]),
                    {error, Reason};
                {'EXIT', Pid, Reason} ->
                    catch safe_apply(R2, close_read, [R2#restore.bup_data]),
                    {error, {'EXIT', Pid, Reason}};
                {'EXIT', Reason} ->
                    catch safe_apply(R2, close_read, [R2#restore.bup_data]),
                    {error, {'EXIT', Reason}}
            end
    end.

iter(R, Header, Schema, Fun, Acc, []) ->
    case safe_apply(R, read, [R#restore.bup_data]) of
        {R2, []} ->
            Res = Fun([], Header, Schema, Acc),
            {ok, R2, Res};
        {R2, BupItems} ->
            iter(R2, Header, Schema, Fun, Acc, BupItems)
    end;
iter(R, Header, Schema, Fun, Acc, BupItems) ->
    Acc2 = Fun(BupItems, Header, Schema, Acc),
    iter(R, Header, Schema, Fun, Acc2, []).

-spec safe_apply(#restore{}, atom(), list()) -> tuple().
safe_apply(R, write, [_, Items]) when Items =:= [] ->
    R;
safe_apply(R, What, Args) ->
    Abort = fun(Re) -> abort_restore(R, What, Args, Re) end,
    %% 得到相应的模块Mod
    Mod = R#restore.bup_module,
    case catch apply(Mod, What, Args) of
	{ok, Opaque, Items} when What =:= read ->
	    {R#restore{bup_data = Opaque}, Items};
	{ok, Opaque}  when What =/= read->
        %% Opaque是上下文
	    R#restore{bup_data = Opaque};
	{error, Re} ->
	    Abort(Re);
	Re ->
	    Abort(Re)
    end.

abort_restore(R, What, Args, Reason) ->
    Mod = R#restore.bup_module,
    Opaque = R#restore.bup_data,
    dbg_out("Restore aborted. ~p:~p~p -> ~p~n",
            [Mod, What, Args, Reason]),
    catch apply(Mod, close_read, [Opaque]),
    throw({error, Reason}).

fallback_to_schema() ->
    Fname = fallback_bup(),
    fallback_to_schema(Fname).

fallback_to_schema(Fname) ->
    Mod = mnesia_backup,
    case read_schema(Mod, Fname) of
        {error, Reason} ->
            {error, Reason};
        Schema ->
            case catch lookup_schema(schema, Schema) of
                {error, _} ->
                    {error, "No schema in fallback"};
                List ->
                    {ok, fallback, List}
            end
    end.

%% Opens Opaque reads schema and then close
read_schema(Mod, Opaque) ->
    R = #restore{bup_module = Mod, bup_data = Opaque},
    case catch read_schema_section(R) of
        {error, Reason} ->
            {error, Reason};
        {R2, {_Header, Schema, _}} ->
            catch safe_apply(R2, close_read, [R2#restore.bup_data]),
            Schema
    end.

%% Open backup media and extract schema
%% rewind backup media and leave it open
%% Returns {R, {Header, Schema}}
read_schema_section(R) ->
    %% R是restore结构，里面包含了操作的进行的模块和操作进行的文件
    case catch do_read_schema_section(R) of
        {'EXIT', Reason} ->
            catch safe_apply(R, close_read, [R#restore.bup_data]),
            {error, {'EXIT', Reason}};
        {error, Reason} ->
            catch safe_apply(R, close_read, [R#restore.bup_data]),
            {error, Reason};
        {R2, {H, Schema, Rest}} ->
            %% 转化Schema，主要是进行升级
            %% 将以前的schema升级到当前版本的schema，主要以及说就是backup_log的版本
            Schema2 = convert_schema(H#log_header.log_version, Schema),
            {R2, {H, Schema2, Rest}}
    end.
%% 读取schema的头
%% 返回的时候会包含，从备份文件中独处的日志头，所有schema元素，以及剩下的数据
do_read_schema_section(R) ->
    %% 首次安装schema的时候，R中的module是mnesia_backup，日志文件只有schema一条纪录
    R2 = safe_apply(R, open_read, [R#restore.bup_data]),
    %% RawSchema为原始的schema数据
    {R3, RawSchema} = safe_apply(R2, read, [R2#restore.bup_data]),
    %% 继续读日志，并校验日志头是否合法
    do_read_schema_section(R3, verify_header(RawSchema), []).
%% 读取到了backup的Header和Current的Header
%% 但是没有读取到Schema的信息
do_read_schema_section(R, {ok, B, C, []}, Acc) ->
    %% 继续读取数据
    case safe_apply(R, read, [R#restore.bup_data]) of
        {R2, []} ->
            %% 没有数据了就返回backup文件中的日志头和Acc
            {R2, {B, Acc, []}};
        {R2, RawSchema} ->
            %% 如果有数据尝试继续读取
            do_read_schema_section(R2, {ok, B, C, RawSchema}, Acc)
    end;

%% 读取出来的tuple的第一元素是schema的时候，就将head放到acc的最后面
%% 并继续读取日志
do_read_schema_section(R, {ok, B, C, [Head | Tail]}, Acc)
        when element(1, Head) =:= schema ->
    do_read_schema_section(R, {ok, B, C, Tail}, Acc ++ [Head]);
%% 如果读取出来的tuple的第一元素不是schema的时候，进行返回
do_read_schema_section(R, {ok, B, _C, Rest}, Acc) ->
    {R, {B, Acc, Rest}};

do_read_schema_section(_R, {error, Reason}, _Acc) ->
    {error, Reason}.
%% 对Schema进行校验
verify_header([H | RawSchema]) when is_record(H, log_header) ->
    %% 得到当前Mnesia的Log头
    Current = mnesia_log:backup_log_header(),
    if
        H#log_header.log_kind =:= Current#log_header.log_kind ->
            Versions = ["0.1", "1.1", Current#log_header.log_version],
            case lists:member(H#log_header.log_version, Versions) of
                true ->
                    %% 如果是合法的日志头文件
                    %% 返回读出来的日志头文件，当前日志头和剩余数据
                    {ok, H, Current, RawSchema};
                false ->
                    {error, {"Bad header version. Cannot be used as backup.", H}}
            end;
        true ->
            {error, {"Bad kind of header. Cannot be used as backup.", H}}
    end;
verify_header(RawSchema) ->
    {error, {"Missing header. Cannot be used as backup.", catch hd(RawSchema)}}.

refresh_cookie(Schema, NewCookie) ->
    case lists:keysearch(schema, 2, Schema) of
        {value, {schema, schema, List}} ->
            Cs = mnesia_schema:list2cs(List),
            Cs2 = Cs#cstruct{cookie = NewCookie},
            Item = {schema, schema, mnesia_schema:cs2list(Cs2)},
            lists:keyreplace(schema, 2, Schema, Item);

        false ->
            Reason = "No schema found. Cannot be used as backup.",
            throw({error, {Reason, Schema}})
    end.

%% Convert schema items from an external backup
%% If backup format is the latest, no conversion is needed
%% All supported backup formats should have their converters
%% here as separate function clauses.
convert_schema("0.1", Schema) ->
    convert_0_1(Schema);
convert_schema("1.1", Schema) ->
    %% The new backup format is a pure extension of the old one
    Current = mnesia_log:backup_log_header(),
    convert_schema(Current#log_header.log_version, Schema);
convert_schema(Latest, Schema) ->
    H = mnesia_log:backup_log_header(),
    if
        H#log_header.log_version =:= Latest ->
            Schema;
        true ->
            Reason = "Bad backup header version. Cannot convert schema.",
            throw({error, {Reason, H}})
    end.

%% Backward compatibility for 0.1
convert_0_1(Schema) ->
    case lists:keysearch(schema, 2, Schema) of
        {value, {schema, schema, List}} ->
            Schema2 = lists:keydelete(schema, 2, Schema),
            Cs = mnesia_schema:list2cs(List),
            convert_0_1(Schema2, [], Cs);
        false ->
            List = mnesia_schema:get_initial_schema(disc_copies, [node()]),
            Cs = mnesia_schema:list2cs(List),
            convert_0_1(Schema, [], Cs)
    end.

convert_0_1([{schema, cookie, Cookie} | Schema], Acc, Cs) ->
    convert_0_1(Schema, Acc, Cs#cstruct{cookie = Cookie});
convert_0_1([{schema, db_nodes, DbNodes} | Schema], Acc, Cs) ->
    convert_0_1(Schema, Acc, Cs#cstruct{disc_copies = DbNodes});
convert_0_1([{schema, version, Version} | Schema], Acc, Cs) ->
    convert_0_1(Schema, Acc, Cs#cstruct{version = Version});
convert_0_1([{schema, Tab, Def} | Schema], Acc, Cs) ->
    Head =
        case lists:keysearch(index, 1, Def) of
            {value, {index, PosList}} ->
                %% Remove the snmp "index"
                P = PosList -- [snmp],
                Def2 = lists:keyreplace(index, 1, Def, {index, P}),
                {schema, Tab, Def2};
            false ->
                {schema, Tab, Def}
        end,
    convert_0_1(Schema, [Head | Acc], Cs);
convert_0_1([Head | Schema], Acc, Cs) ->
    convert_0_1(Schema, [Head | Acc], Cs);
convert_0_1([], Acc, Cs) ->
    [schema2bup({schema, schema, Cs}) | Acc].

%% Returns Val or throw error
lookup_schema(Key, Schema) ->
    case lists:keysearch(Key, 2, Schema) of
        {value, {schema, Key, Val}} -> Val;
        false -> throw({error, {"Cannot lookup", Key}})
    end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Backup compatibility

%% Convert internal schema items to backup dito
schema2bup({schema, Tab}) ->
    {schema, Tab};
schema2bup({schema, Tab, TableDef}) ->
    {schema, Tab, mnesia_schema:cs2list(TableDef)}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create schema on the given nodes
%% Requires that old schemas has been deleted
%% Returns ok | {error, Reason}
%% create_schema只是创建了一个FALLBACK.BUP的文件
%% 真正产生schema.DAT文件是发生在mnesia:start的时候
create_schema([]) ->
    create_schema([node()]);
create_schema(Ns) when is_list(Ns) ->
    case is_set(Ns) of
        true ->
            create_schema(Ns, mnesia_schema:ensure_no_schema(Ns));
        false ->
            {error, {combine_error, Ns}}
    end;
create_schema(Ns) ->
    {error, {badarg, Ns}}.

is_set(List) when is_list(List) ->
    ordsets:is_set(lists:sort(List));
is_set(_) ->
    false.

create_schema(Ns, ok) ->
    %% Ensure that we access the intended Mnesia
    %% directory. This function may not be called
    %% during startup since it will cause the
    %% application_controller to get into deadlock
    case mnesia_lib:ensure_loaded(?APPLICATION) of
        ok ->
            case mnesia_monitor:get_env(schema_location) of
                ram ->
                    {error, {has_no_disc, node()}};
                _ ->
                    %% 磁盘节点需要先确保相应的路径
                    case mnesia_schema:opt_create_dir(true, mnesia_lib:dir()) of
                        {error, What} ->
                            {error, What};
                        ok ->
                            Mod = mnesia_backup,
                            Str = mk_str(),
                            %% 先创建一个临时的文件，结尾为.TMP
                            File = mnesia_lib:dir(Str),
                            file:delete(File),
                            case catch make_initial_backup(Ns, File, Mod) of
                                {ok, _Res} ->
                                    %创建成功后，安装备份
                                    case do_install_fallback(File, Mod) of
                                        ok ->
                                            %% 备份安装成功了，删除临时文件
                                            file:delete(File),
                                            ok;
                                        {error, Reason} ->
                                            {error, Reason}
                                    end;
                                {error, Reason} ->
                                    {error, Reason}
                            end
                    end
            end;
        {error, Reason} ->
            {error, Reason}
    end;
create_schema(_Ns, {error, Reason}) ->
    {error, Reason};
create_schema(_Ns, Reason) ->
    {error, Reason}.

mk_str() ->
    Now = [integer_to_list(I) || I <- tuple_to_list(now())],
    lists:concat([node()] ++ Now ++ ".TMP").
%创建schema的临时文件
%NS为所有的节点，Opadue是临时文件名
%Mod是mnesia_backup
make_initial_backup(Ns, Opaque, Mod) ->
    %%获取最开始的元数据表
    %%元数据是cstruct的[{key,value}]形式
    Orig = mnesia_schema:get_initial_schema(disc_copies, Ns),
    %% 删除掉storage_properties和majority这两个字段
    Modded = proplists:delete(storage_properties, proplists:delete(majority, Orig)),
    %% 向schema表中写入表名和cstruct
    Schema = [{schema, schema, Modded}],
    O2 = do_apply(Mod, open_write, [Opaque], Opaque),
    %写入日志头
    %% 包括日志版本，日志类型，mnesia版本，节点名称，生成时间
    %% 这里日志版本1.2  类型 backup_log
    O3 = do_apply(Mod, write, [O2, [mnesia_log:backup_log_header()]], O2),
    %写入schema数据
    O4 = do_apply(Mod, write, [O3, Schema], O3),
    %%生成Opaque所代表的文件
    O5 = do_apply(Mod, commit_write, [O4], O4),
    {ok, O5}.

do_apply(_, write, [_, Items], Opaque) when Items =:= [] ->
    Opaque;
do_apply(Mod, What, Args, _Opaque) ->
    case catch apply(Mod, What, Args) of
        {ok, Opaque2} ->  Opaque2;
        {error, Reason} -> throw({error, Reason});
        {'EXIT', Reason} -> throw({error, {'EXIT', Reason}})
    end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Restore

%% Restore schema and possibly other tables from a backup
%% and replicate them to the necessary nodes
%% Requires that old schemas has been deleted
%% Returns ok | {error, Reason}
install_fallback(Opaque) ->
    install_fallback(Opaque, []).

install_fallback(Opaque, Args) ->
    %% Ensure that we access the intended Mnesia
    %% directory. This function may not be called
    %% during startup since it will cause the
    %% application_controller to get into deadlock
    case mnesia_lib:ensure_loaded(?APPLICATION) of
        ok ->
            do_install_fallback(Opaque, Args);
        {error, Reason} ->
            {error, Reason}
    end.

do_install_fallback(Opaque,  Mod) when is_atom(Mod) ->
    do_install_fallback(Opaque, [{module, Mod}]);
do_install_fallback(Opaque, Args) when is_list(Args) ->
    %% 检查参数合法性
    case check_fallback_args(Args, #fallback_args{opaque = Opaque}) of
        {ok, FA} ->
            do_install_fallback(FA);
        {error, Reason} ->
            {error, Reason}
    end;
do_install_fallback(_Opaque, Args) ->
    {error, {badarg, Args}}.

check_fallback_args([Arg | Tail], FA) ->
    case catch check_fallback_arg_type(Arg, FA) of
        {'EXIT', _Reason} ->
            {error, {badarg, Arg}};
        FA2 ->
            check_fallback_args(Tail, FA2)
    end;
check_fallback_args([], FA) ->
    {ok, FA}.

check_fallback_arg_type(Arg, FA) ->
    case Arg of
        {scope, global} ->
            FA#fallback_args{scope = global};
        {scope, local} ->
            FA#fallback_args{scope = local};
        {module, Mod} ->
            Mod2 = mnesia_monitor:do_check_type(backup_module, Mod),
            FA#fallback_args{module = Mod2};
        {mnesia_dir, Dir} ->
            FA#fallback_args{mnesia_dir = Dir,
                             use_default_dir = false};
        {keep_tables, Tabs} ->
            atom_list(Tabs),
            FA#fallback_args{keep_tables = Tabs};
        {skip_tables, Tabs} ->
            atom_list(Tabs),
            FA#fallback_args{skip_tables = Tabs};
        {default_op, keep_tables} ->
            FA#fallback_args{default_op = keep_tables};
        {default_op, skip_tables} ->
            FA#fallback_args{default_op = skip_tables}
    end.

atom_list([H | T]) when is_atom(H) ->
    atom_list(T);
atom_list([]) ->
    ok.
%创建备份安装进程
do_install_fallback(FA) ->
    %% 创建一个进程来安装备份
    %% 防止当前进程崩溃打断安装
    Pid = spawn_link(?MODULE, install_fallback_master, [self(), FA]),
    Res =
        receive
            {'EXIT', Pid, Reason} -> % if appl has trapped exit
                {error, {'EXIT', Reason}};
            {Pid, Res2} ->
                case Res2 of
                    {ok, _} ->
                        ok;
                    {error, Reason} ->
                        {error, {"Cannot install fallback", Reason}}
                end
        end,
    Res.

install_fallback_master(ClientPid, FA) ->
    %% 捕获退出异常，关联进程崩溃，但是并不真正捕获
    %% 而是防止崩溃后引起当前进程退出，打断元数据创建
    process_flag(trap_exit, true),
    %% 设置状态
    State = {start, FA},
    %% 拿出日志文件
    Opaque = FA#fallback_args.opaque,
    Mod = FA#fallback_args.module,
    Res = (catch iterate(Mod, fun restore_recs/4, Opaque, State)),
    unlink(ClientPid),
    ClientPid ! {self(), Res},
    exit(shutdown).

restore_recs(_, _, _, stop) ->
    throw({error, "restore_recs already stopped"});
%第一个参数是余下的Records
%第二个参数是Header，用来判断版本
%第三个参数是schema
%第四个参数是状态
restore_recs(Recs, Header, Schema, {start, FA}) ->
    %% No records in backup
    Schema2 = convert_schema(Header#log_header.log_version, Schema),
    %% 在backup文件中读取出的schema信息找出schema的信息
    CreateList = lookup_schema(schema, Schema2),
    case catch mnesia_schema:list2cs(CreateList) of
        {'EXIT', Reason} ->
            throw({error, {"Bad schema in restore_recs", Reason}});
        Cs ->
        %找到备份节点
            Ns = get_fallback_nodes(FA, Cs#cstruct.disc_copies),
            global:set_lock({{mnesia_table_lock, schema}, self()}, Ns, infinity),
            Args = [self(), FA],
            %创建出一组fallback_receiver，有多少个NS就建立多少个
            %每个节点上都有一个fallback_receiver进程
            Pids = [spawn_link(N, ?MODULE, fallback_receiver, Args) || N <- Ns],
            %给所有进程发送start消息，并收集结果
            send_fallback(Pids, {start, Header, Schema2}),
            Res = restore_recs(Recs, Header, Schema2, Pids),
            global:del_lock({{mnesia_table_lock, schema}, self()}, Ns),
            Res
    end;
%% 第二次进入这个函数的时候，ACC就是远程节点上 fallback_receiver的进程了
%% 恢复数据的过程中，无视远程节点的返回值
%没有更多records了，进行swap
restore_recs([], _Header, _Schema, Pids) ->
    send_fallback(Pids, swap),
    send_fallback(Pids, stop),
    stop;

restore_recs(Recs, _, _, Pids) ->
    send_fallback(Pids, {records, Recs}),
    Pids.

get_fallback_nodes(FA, Ns) ->
    This = node(),
    case lists:member(This, Ns) of
        true ->
            case FA#fallback_args.scope of
                global ->  Ns;
                local -> [This]
            end;
        false ->
            throw({error, {"No disc resident schema on local node", Ns}})
    end.

send_fallback(Pids, Msg) when is_list(Pids), Pids =/= [] ->
    lists:foreach(fun(Pid) -> Pid ! {self(), Msg} end, Pids),
    rec_answers(Pids, []).

rec_answers([], Acc) ->
    case {lists:keysearch(error, 1, Acc), mnesia_lib:uniq(Acc)} of
        {{value, {error, Val}}, _} -> throw({error, Val});
        {_, [SameAnswer]} -> SameAnswer;
        {_, Other} -> throw({error, {"Different answers", Other}})
    end;
rec_answers(Pids, Acc) ->
    receive
        {'EXIT', Pid, stopped} ->
            Pids2 = lists:delete(Pid, Pids),
            rec_answers(Pids2, [stopped|Acc]);
        {'EXIT', Pid, Reason} ->
            Pids2 = lists:delete(Pid, Pids),
            rec_answers(Pids2, [{error, {'EXIT', Pid, Reason}}|Acc]);
        {Pid, Reply} ->
            Pids2 = lists:delete(Pid, Pids),
            rec_answers(Pids2, [Reply|Acc])
    end.

fallback_exists() ->
    Fname = fallback_bup(),
    fallback_exists(Fname).

fallback_exists(Fname) ->
    case mnesia_monitor:use_dir() of
        true ->
            mnesia_lib:exists(Fname);
        false ->
            case ?catch_val(active_fallback) of
                {'EXIT', _} -> false;
                Bool -> Bool
            end
    end.
%有这文件就代表Mnesia有需要回滚的事务
fallback_name() -> "FALLBACK.BUP".
fallback_bup() -> mnesia_lib:dir(fallback_name()).

fallback_tmp_name() -> "FALLBACK.TMP".
%% fallback_full_tmp_name() -> mnesia_lib:dir(fallback_tmp_name()).

-spec fallback_receiver(pid(), fallback_args()) -> no_return().
%Master,在此处表示，整个mnesia集群在create_schema的时候的发起者
fallback_receiver(Master, FA) ->
    process_flag(trap_exit, true),
%将自己注册到本地名字库，防止创建出另一个fallback_receiver进程
    case catch register(mnesia_fallback, self()) of
        {'EXIT', _} ->
            Reason = {already_exists, node()},
            local_fallback_error(Master, Reason);
        true ->
            FA2 = check_fallback_dir(Master, FA),
            Bup = FA2#fallback_args.fallback_bup,
            %检查是否有backup
            case mnesia_lib:exists(Bup) of
                true ->
                    %如果有则报错
                    Reason2 = {already_exists, node()},
                    local_fallback_error(Master, Reason2);
                false ->
                    %如果没有，创建新的backup的临时文件
                    Mod = mnesia_backup,
                    %% 删除FALLBACK.TMP文件
                    Tmp = FA2#fallback_args.fallback_tmp,
                    R = #restore{mode = replace,
                                 bup_module = Mod,
                                 bup_data = Tmp},
                    file:delete(Tmp),
                    %开始接收fallback信息
                    case catch fallback_receiver_loop(Master, R, FA2, schema) of
                        {error, Reason} ->
                            local_fallback_error(Master, Reason);
                        Other ->
                            exit(Other)
                    end
            end
    end.

local_fallback_error(Master, Reason) ->
    Master ! {self(), {error, Reason}},
    unlink(Master),
    exit(Reason).

check_fallback_dir(Master, FA) ->
    %% 得到schema所在的位置
    case mnesia:system_info(schema_location) of
        ram ->
            Reason = {has_no_disc, node()},
            local_fallback_error(Master, Reason);
        _ ->
            Dir = check_fallback_dir_arg(Master, FA),
            Bup = filename:join([Dir, fallback_name()]),
            Tmp = filename:join([Dir, fallback_tmp_name()]),
            FA#fallback_args{fallback_bup = Bup,
                             fallback_tmp = Tmp,
                             mnesia_dir = Dir}
    end.

check_fallback_dir_arg(Master, FA) ->
    case FA#fallback_args.use_default_dir of
        true ->
            mnesia_lib:dir();
        false when FA#fallback_args.scope =:= local ->
            Dir = FA#fallback_args.mnesia_dir,
            case catch mnesia_monitor:do_check_type(dir, Dir) of
                {'EXIT', _R} ->
                    Reason = {badarg, {dir, Dir}, node()},
                    local_fallback_error(Master, Reason);
                AbsDir->
                    AbsDir
            end;
        false when FA#fallback_args.scope =:= global ->
            Reason = {combine_error, global, dir, node()},
            local_fallback_error(Master, Reason)
    end.

fallback_receiver_loop(Master, R, FA, State) ->
    receive
        {Master, {start, Header, Schema}} when State =:= schema ->
            Dir = FA#fallback_args.mnesia_dir,
            throw_bad_res(ok, mnesia_schema:opt_create_dir(true, Dir)),
            %% 创建FALLBACK.TMP文件
            R2 = safe_apply(R, open_write, [R#restore.bup_data]),
            R3 = safe_apply(R2, write, [R2#restore.bup_data, [Header]]),
            BupSchema = [schema2bup(S) || S <- Schema],
            R4 = safe_apply(R3, write, [R3#restore.bup_data, BupSchema]),
            Master ! {self(), ok},
            %% schema的日志已经写入文件了
            %% 状态切换到接收records
            fallback_receiver_loop(Master, R4, FA, records);

        {Master, {records, Recs}} when State =:= records ->
            R2 = safe_apply(R, write, [R#restore.bup_data, Recs]),
            Master ! {self(), ok},
            fallback_receiver_loop(Master, R2, FA, records);
        %收到swap，进行commit，并将临时文件重命名为backup文件
        {Master, swap} when State =/= schema ->
            ?eval_debug_fun({?MODULE, fallback_receiver_loop, pre_swap}, []),
            safe_apply(R, commit_write, [R#restore.bup_data]),
            Bup = FA#fallback_args.fallback_bup,
            Tmp = FA#fallback_args.fallback_tmp,
            %% 立刻重命名文件，将FALLBACK.TMP重命名为FALLBACK.BUP
            throw_bad_res(ok, file:rename(Tmp, Bup)),
            catch mnesia_lib:set(active_fallback, true),
            ?eval_debug_fun({?MODULE, fallback_receiver_loop, post_swap}, []),
            Master ! {self(), ok},
            fallback_receiver_loop(Master, R, FA, stop);

        {Master, stop} when State =:= stop ->
            stopped;

        Msg ->
            safe_apply(R, abort_write, [R#restore.bup_data]),
            Tmp = FA#fallback_args.fallback_tmp,
            file:delete(Tmp),
            throw({error, "Unexpected msg fallback_receiver_loop", Msg})
    end.

throw_bad_res(Expected, Expected) -> Expected;
throw_bad_res(_Expected, {error, Actual}) -> throw({error, Actual});
throw_bad_res(_Expected, Actual) -> throw({error, Actual}).

-record(local_tab, {name,
                    storage_type,
                    open,
                    add,
                    close,
		    swap,
                    record_name,
                    opened}).

tm_fallback_start(IgnoreFallback) ->
    %% 锁定元数据表
    %% 从mnesia_tm的init进到此处的时候
    %% 申请加锁的进程是新建立的mnesia_tm进程
    mnesia_schema:lock_schema(),
    %% 检查是否有fallback文件，FALLBACK.BUP
    %% 并从fallback.BUP中进行数据恢复
    Res = do_fallback_start(fallback_exists(), IgnoreFallback),
    mnesia_schema:unlock_schema(),
    case Res of
        ok -> ok;
        {error, Reason} -> exit(Reason)
    end.
%% 不存在FALLBACk.BUP的时候，就直接返回
do_fallback_start(false, _IgnoreFallback) ->
    ok;
%% 存在FALLBACk.BUP的时候，并强制忽略
%% 但是会设置active_fallback标记为true
do_fallback_start(true, true) ->
    verbose("Ignoring fallback at startup, but leaving it active...~n", []),
    mnesia_lib:set(active_fallback, true),
    ok;
%执行回滚操作
do_fallback_start(true, false) ->
    verbose("Starting from fallback...~n", []),
    %拿到备份文件
    BupFile = fallback_bup(),
    Mod = mnesia_backup,
    %创建一个ets，用来保存本地表
    LocalTabs = ?ets_new_table(mnesia_local_tables, [set, public, {keypos, 2}]),
    case catch iterate(Mod, fun restore_tables/4, BupFile, {start, LocalTabs}) of
        {ok, _Res} ->
            %%  让dets关闭掉schema
            catch dets:close(schema),
            %% 设置临时的文件为schema.TMP
            TmpSchema = mnesia_lib:tab2tmp(schema),
            %% 设置数据文件为schema.DAT
            DatSchema = mnesia_lib:tab2dat(schema),
            %% 得到所有本地表
	          AllLT  = ?ets_match_object(LocalTabs, '_'),
            %关闭ets
	          ?ets_delete_table(LocalTabs),
            %% schema.TMP重命名为schema.DAT
            case file:rename(TmpSchema, DatSchema) of
                ok ->
                    %% 除了schema表外，全部进行swap操作
		                [(LT#local_tab.swap)(LT#local_tab.name, LT) ||
			                 LT <- AllLT, LT#local_tab.name =/= schema],
                    file:delete(BupFile),
                    ok;
                {error, Reason} ->
                    file:delete(TmpSchema),
                    {error, {"Cannot start from fallback. Rename error.", Reason}}
            end;
        {error, Reason} ->
            {error, {"Cannot start from fallback", Reason}};
        {'EXIT', Reason} ->
            {error, {"Cannot start from fallback", Reason}}
    end.
%% 对表进行数据恢复
restore_tables(All=[Rec | Recs], Header, Schema, State={local, LocalTabs, LT}) ->
    Tab = element(1, Rec),
    if
        Tab =:= LT#local_tab.name ->
            Key = element(2, Rec),
            (LT#local_tab.add)(Tab, Key, Rec, LT),
            restore_tables(Recs, Header, Schema, State);
        true ->
            NewState = {new, LocalTabs},
            restore_tables(All, Header, Schema, NewState)
    end;
restore_tables(All=[Rec | Recs], Header, Schema, {new, LocalTabs}) ->
    Tab = element(1, Rec),
    %% 根据record的名字去查找表
    case ?ets_lookup(LocalTabs, Tab) of
        [] ->
          State = {not_local, LocalTabs, Tab},
          restore_tables(Recs, Header, Schema, State);
        [LT] when is_record(LT, local_tab) ->
	        State = {local, LocalTabs, LT},
	        case LT#local_tab.opened of
		        true ->  ignore;
		        false ->
		          (LT#local_tab.open)(Tab, LT),
		          ?ets_insert(LocalTabs,LT#local_tab{opened=true})
	        end,
          %% 打开表，并进行数据恢复
          restore_tables(All, Header, Schema, State)
    end;
%% 忽略掉所有不在mnesia_local_tables中的数据元素
restore_tables(All=[Rec | Recs], Header, Schema, S = {not_local, LocalTabs, PrevTab}) ->
    Tab = element(1, Rec),
    if
        Tab =:= PrevTab ->
            restore_tables(Recs, Header, Schema, S);
        true ->
            State = {new, LocalTabs},
            restore_tables(All, Header, Schema, State)
    end;
%% 第一次执行，会从此处开始
restore_tables(Recs, Header, Schema, {start, LocalTabs}) ->
    %% 获取mneisa的目录
    Dir = mnesia_lib:dir(),
    OldDir = filename:join([Dir, "OLD_DIR"]),
    %% 删除OLD_DIR下的数据
    mnesia_schema:purge_dir(OldDir, []),
    %% 删除Mnesia目录下除FALLBACK.BUP文件的所有其它文件
    mnesia_schema:purge_dir(Dir, [fallback_name()]),
    %% 初始化本DAT文件，Schema为FALLBCK.BUP中的Schema数据
    %% 将Schema全都写入schema.DAT中
    %% 为每个Table创建.DAT,.DCL,.DCD和.TMP文件
    %% 为每个Table创建local_tab的record,并保存到mnesia_local_tables中
    init_dat_files(Schema, LocalTabs),
    State = {new, LocalTabs},
    %% 更改状态，开始创建表
    restore_tables(Recs, Header, Schema, State);
restore_tables([], _Header, _Schema, State) ->
    State.

%% Creates all neccessary dat files and inserts
%% the table definitions in the schema table
%%
%% Returns a list of local_tab tuples for all local tables
init_dat_files(Schema, LocalTabs) ->
    %% 创建schma的tmp文件
    TmpFile = mnesia_lib:tab2tmp(schema),
    Args = [{file, TmpFile}, {keypos, 2}, {type, set}],
    %% dets 打开文件
    case dets:open_file(schema, Args) of % Assume schema lock
        {ok, _} ->
            %% 遍历Schema这个列表
            %% 创建缺失文件，并将{schema,Tab,TabDef}数据写入schema.DAT中
            create_dat_files(Schema, LocalTabs),
            ok = dets:close(schema),
            LocalTab = #local_tab{name         = schema,
                                  storage_type = disc_copies,
                                  open         = undefined,
                                  add          = undefined,
                                  close        = undefined,
				  swap         = undefined,
                                  record_name  = schema,
                                  opened = false},
            %% 向ets临时表mnesia_local_tables
            %% 放入schma表的信息
            ?ets_insert(LocalTabs, LocalTab);
        {error, Reason} ->
            throw({error, {"Cannot open file", schema, Args, Reason}})
    end.

create_dat_files([{schema, schema, TabDef} | Tail], LocalTabs) ->
    ok = dets:insert(schema, {schema, schema, TabDef}),
    create_dat_files(Tail, LocalTabs);
create_dat_files([{schema, Tab, TabDef} | Tail], LocalTabs) ->
    TmpFile = mnesia_lib:tab2tmp(Tab),
    DatFile = mnesia_lib:tab2dat(Tab),
    %% 创建日志文件.DCL和.DCD
    %% mneisa会将操作写入.DCL中
    %% 当DCL太大了会压缩成.DCD文件
    DclFile = mnesia_lib:tab2dcl(Tab),
    DcdFile = mnesia_lib:tab2dcd(Tab),
    Expunge = fun() ->
		      file:delete(DatFile),
		      file:delete(DclFile),
		      file:delete(DcdFile)
	      end,

    mnesia_lib:dets_sync_close(Tab),
    file:delete(TmpFile),
    Cs = mnesia_schema:list2cs(TabDef),
    %% 会在schema的dets文件中插入表定义
    ok = dets:insert(schema, {schema, Tab, TabDef}),
    RecName = Cs#cstruct.record_name,
    Storage = mnesia_lib:cs_to_storage_type(node(), Cs),
    if
	    Storage =:= unknown ->
        ok = dets:delete(schema, {schema, Tab}),
        create_dat_files(Tail, LocalTabs);
      Storage =:= disc_only_copies ->
        Args = [{file, TmpFile}, {keypos, 2},
                type, mnesia_lib:disk_type(Tab, Cs#cstruct.type)}],
        %% disc_only模式下打开函数
        Open = fun(T, LT) when T =:= LT#local_tab.name ->
                  case mnesia_lib:dets_sync_open(T, Args) of
                    {ok, _} -> ok;
                    {error, Reason} -> throw({error, {"Cannot open file", T, Args, Reason}})
                  end
                end,
        %% disc_only模式下添加数据函数
        Add = fun(T, Key, Rec, LT) when T =:= LT#local_tab.name ->
                  case Rec of
                    {_T, Key} -> ok = dets:delete(T, Key);
                    (Rec) when T =:= RecName -> ok = dets:insert(Tab, Rec);
                    (Rec) ->
                        Rec2 = setelement(1, Rec, RecName),
                        ok = dets:insert(T, Rec2)
                  end
              end,
        %% disc_only模式下关闭函数
        Close = fun(T, LT) when T =:= LT#local_tab.name ->
                    mnesia_lib:dets_sync_close(T)
                end,
	      Swap = fun(T, LT) when T =:= LT#local_tab.name ->
                  Expunge(),
                  case LT#local_tab.opened of
			              true -> Close(T,LT);
			              false ->
                      Open(T,LT),
				              Close(T,LT)
			            end,
                  %% 临时文件变成正式文件
			            case file:rename(TmpFile, DatFile) of
                    ok -> ok;
			              {error, Reason} ->
                      mnesia_lib:fatal("Cannot rename file ~p -> ~p: ~p~n",
						          [TmpFile, DatFile, Reason])
			            end
		            end,
        LocalTab = #local_tab{name         = Tab,
                                  storage_type = Storage,
                                  open         = Open,
                                  add          = Add,
                                  close        = Close,
				                          swap         = Swap,
                                  record_name  = RecName,
                                  opened       = false},
            %% 保存到localTab中
            ?ets_insert(LocalTabs, LocalTab),
	          create_dat_files(Tail, LocalTabs);
      Storage =:= ram_copies; Storage =:= disc_copies ->
	      Open = fun(T, LT) when T =:= LT#local_tab.name ->
			   mnesia_log:open_log({?MODULE, T},
					       mnesia_log:dcl_log_header(),
					       TmpFile,
					       false,
					       false,
					       read_write)
		   end,
            Add = fun(T, Key, Rec, LT) when T =:= LT#local_tab.name ->
			  Log = {?MODULE, T},
			  case Rec of
			      {_T, Key} ->
				  mnesia_log:append(Log, {{T, Key}, {T, Key}, delete});
			      (Rec) when T =:= RecName ->
				  mnesia_log:append(Log, {{T, Key}, Rec, write});
			      (Rec) ->
				  Rec2 = setelement(1, Rec, RecName),
				  mnesia_log:append(Log, {{T, Key}, Rec2, write})
			  end
		  end,
            Close = fun(T, LT) when T =:= LT#local_tab.name ->
			    mnesia_log:close_log({?MODULE, T})
                    end,
	    Swap = fun(T, LT) when T =:= LT#local_tab.name ->
			   Expunge(),
			   if
			       Storage =:= ram_copies, LT#local_tab.opened =:= false ->
				   ok;
			       true ->
				   Log = mnesia_log:open_log(fallback_tab,
							     mnesia_log:dcd_log_header(),
							     DcdFile,
							     false),
				   mnesia_log:close_log(Log),
				   case LT#local_tab.opened of
				       true ->
					   Close(T,LT);
				       false ->
					   Open(T,LT),
					   Close(T,LT)
				   end,
				   case file:rename(TmpFile, DclFile) of
				       ok ->
					   ok;
				       {error, Reason} ->
					   mnesia_lib:fatal("Cannot rename file ~p -> ~p: ~p~n",
							    [TmpFile, DclFile, Reason])
				   end
			   end
		   end,
            LocalTab = #local_tab{name         = Tab,
                                  storage_type = Storage,
                                  open         = Open,
                                  add          = Add,
                                  close        = Close,
				  swap         = Swap,
                                  record_name  = RecName,
				  opened       = false
				 },
            ?ets_insert(LocalTabs, LocalTab),
            create_dat_files(Tail, LocalTabs)
    end;
create_dat_files([{schema, Tab} | Tail], LocalTabs) ->
    ?ets_delete(LocalTabs, Tab),
    ok = dets:delete(schema, {schema, Tab}),
    TmpFile = mnesia_lib:tab2tmp(Tab),
    mnesia_lib:dets_sync_close(Tab),
    file:delete(TmpFile),
    create_dat_files(Tail, LocalTabs);
create_dat_files([], _LocalTabs) ->
    ok.

uninstall_fallback() ->
    uninstall_fallback([{scope, global}]).

uninstall_fallback(Args) ->
    case check_fallback_args(Args, #fallback_args{}) of
        {ok, FA} ->
            do_uninstall_fallback(FA);
        {error, Reason} ->
            {error, Reason}
    end.

do_uninstall_fallback(FA) ->
    %% Ensure that we access the intended Mnesia
    %% directory. This function may not be called
    %% during startup since it will cause the
    %% application_controller to get into deadlock
    case mnesia_lib:ensure_loaded(?APPLICATION) of
        ok ->
            Pid = spawn_link(?MODULE, uninstall_fallback_master, [self(), FA]),
            receive
                {'EXIT', Pid, Reason} -> % if appl has trapped exit
                    {error, {'EXIT', Reason}};
                {Pid, Res} ->
                    Res
            end;
        {error, Reason} ->
            {error, Reason}
    end.

-spec uninstall_fallback_master(pid(), fallback_args()) -> no_return().
uninstall_fallback_master(ClientPid, FA) ->
    process_flag(trap_exit, true),

    FA2 = check_fallback_dir(ClientPid, FA), % May exit
    Bup = FA2#fallback_args.fallback_bup,
    case fallback_to_schema(Bup) of
        {ok, fallback, List} ->
            Cs = mnesia_schema:list2cs(List),
            case catch get_fallback_nodes(FA, Cs#cstruct.disc_copies) of
                Ns when is_list(Ns) ->
                    do_uninstall(ClientPid, Ns, FA);
                {error, Reason} ->
                    local_fallback_error(ClientPid, Reason)
            end;
        {error, Reason} ->
            local_fallback_error(ClientPid, Reason)
    end.

do_uninstall(ClientPid, Ns, FA) ->
    Args = [self(), FA],
    global:set_lock({{mnesia_table_lock, schema}, self()}, Ns, infinity),
    Pids = [spawn_link(N, ?MODULE, local_uninstall_fallback, Args) || N <- Ns],
    Res = do_uninstall(ClientPid, Pids, [], [], ok),
    global:del_lock({{mnesia_table_lock, schema}, self()}, Ns),
    ClientPid ! {self(), Res},
    unlink(ClientPid),
    exit(shutdown).

do_uninstall(ClientPid, [Pid | Pids], GoodPids, BadNodes, Res) ->
    receive
        %% {'EXIT', ClientPid, _} ->
        %% client_exit;
        {'EXIT', Pid, Reason} ->
            BadNode = node(Pid),
            BadRes = {error, {"Uninstall fallback", BadNode, Reason}},
            do_uninstall(ClientPid, Pids, GoodPids, [BadNode | BadNodes], BadRes);
        {Pid, {error, Reason}} ->
            BadNode = node(Pid),
            BadRes = {error, {"Uninstall fallback", BadNode, Reason}},
            do_uninstall(ClientPid, Pids, GoodPids, [BadNode | BadNodes], BadRes);
        {Pid, started} ->
            do_uninstall(ClientPid, Pids, [Pid | GoodPids], BadNodes, Res)
    end;
do_uninstall(ClientPid, [], GoodPids, [], ok) ->
    lists:foreach(fun(Pid) -> Pid ! {self(), do_uninstall} end, GoodPids),
    rec_uninstall(ClientPid, GoodPids, ok);
do_uninstall(_ClientPid, [], GoodPids, BadNodes, BadRes) ->
    lists:foreach(fun(Pid) -> exit(Pid, shutdown) end, GoodPids),
    {error, {node_not_running, BadNodes, BadRes}}.

local_uninstall_fallback(Master, FA) ->
    %% Don't trap exit

    register(mnesia_fallback, self()),        % May exit
    FA2 = check_fallback_dir(Master, FA), % May exit
    Master ! {self(), started},

    receive
        {Master, do_uninstall} ->
            ?eval_debug_fun({?MODULE, uninstall_fallback2, pre_delete}, []),
            catch mnesia_lib:set(active_fallback, false),
            Tmp = FA2#fallback_args.fallback_tmp,
            Bup = FA2#fallback_args.fallback_bup,
            file:delete(Tmp),
            Res = file:delete(Bup),
            ?eval_debug_fun({?MODULE, uninstall_fallback2, post_delete}, []),
            Master ! {self(), Res},
            unlink(Master),
            exit(normal)
    end.

rec_uninstall(ClientPid, [Pid | Pids], AccRes) ->
    receive
        %% {'EXIT', ClientPid, _} ->
        %% exit(shutdown);
        {'EXIT', Pid, R} ->
            Reason = {node_not_running, {node(Pid), R}},
            rec_uninstall(ClientPid, Pids, {error, Reason});
        {Pid, ok} ->
            rec_uninstall(ClientPid, Pids, AccRes);
        {Pid, BadRes} ->
            rec_uninstall(ClientPid, Pids, BadRes)
    end;
rec_uninstall(ClientPid, [], Res) ->
    ClientPid ! {self(), Res},
    unlink(ClientPid),
    exit(normal).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Backup traversal

%% Iterate over a backup and produce a new backup.
%% Fun(BackupItem, Acc) is applied for each BackupItem.
%%
%% Valid BackupItems are:
%%
%%   {schema, Tab}              Table to be deleted
%%   {schema, Tab, CreateList}  Table to be created, CreateList may be empty
%%   {schema, db_nodes, DbNodes}List of nodes, defaults to [node()] OLD
%%   {schema, version, Version} Schema version                      OLD
%%   {schema, cookie, Cookie}   Unique schema cookie                OLD
%%   {Tab, Key}                 Oid for record to be deleted
%%   Record                     Record to be inserted.
%%
%% The Fun must return a tuple {BackupItems, NewAcc}
%% where BackupItems is a list of valid BackupItems and
%% NewAcc is a new accumulator value. Once BackupItems
%% that not are schema  related has been returned, no more schema
%% items may be  returned. The schema related items must always be
%% first in the backup.
%%
%% If TargetMod =:= read_only, no new backup will be created.
%%
%% Opening of the source media will be performed by
%% to SourceMod:open_read(Source)
%%
%% Opening of the target media will be performed by
%% to TargetMod:open_write(Target)
traverse_backup(Source, Target, Fun, Acc) ->
    Mod = mnesia_monitor:get_env(backup_module),
    traverse_backup(Source, Mod, Target, Mod, Fun, Acc).

traverse_backup(Source, SourceMod, Target, TargetMod, Fun, Acc) ->
    Args = [self(), Source, SourceMod, Target, TargetMod, Fun, Acc],
    Pid = spawn_link(?MODULE, do_traverse_backup, Args),
    receive
        {'EXIT', Pid, Reason} ->
            {error, {"Backup traversal crashed", Reason}};
        {iter_done, Pid, Res} ->
            Res
    end.

do_traverse_backup(ClientPid, Source, SourceMod, Target, TargetMod, Fun, Acc) ->
    process_flag(trap_exit, true),
    Iter =
        if
            TargetMod =/= read_only ->
                case catch do_apply(TargetMod, open_write, [Target], Target) of
                    {error, Error} ->
                        unlink(ClientPid),
                        ClientPid ! {iter_done, self(), {error, Error}},
                        exit(Error);
                    Else -> Else
                end;
            true ->
                ignore
        end,
    A = {start, Fun, Acc, TargetMod, Iter},
    Res =
        case iterate(SourceMod, fun trav_apply/4, Source, A) of
            {ok, {iter, _, Acc2, _, Iter2}} when TargetMod =/= read_only ->
                case catch do_apply(TargetMod, commit_write, [Iter2], Iter2) of
                    {error, Reason} ->
                        {error, Reason};
                    _ ->
                        {ok, Acc2}
                end;
            {ok, {iter, _, Acc2, _, _}} ->
                {ok, Acc2};
            {error, Reason} when TargetMod =/= read_only->
                catch do_apply(TargetMod, abort_write, [Iter], Iter),
                {error, {"Backup traversal failed", Reason}};
            {error, Reason} ->
                {error, {"Backup traversal failed", Reason}}
        end,
    unlink(ClientPid),
    ClientPid ! {iter_done, self(), Res}.

trav_apply(Recs, _Header, _Schema, {iter, Fun, Acc, Mod, Iter}) ->
    {NewRecs, Acc2} = filter_foldl(Fun, Acc, Recs),
    if
        Mod =/= read_only, NewRecs =/= [] ->
            Iter2 = do_apply(Mod, write, [Iter, NewRecs], Iter),
            {iter, Fun, Acc2, Mod, Iter2};
        true ->
            {iter, Fun, Acc2, Mod, Iter}
    end;
trav_apply(Recs, Header, Schema, {start, Fun, Acc, Mod, Iter}) ->
    Iter2 =
        if
            Mod =/= read_only ->
                do_apply(Mod, write, [Iter, [Header]], Iter);
            true ->
                Iter
        end,
    TravAcc = trav_apply(Schema, Header, Schema, {iter, Fun, Acc, Mod, Iter2}),
    trav_apply(Recs, Header, Schema, TravAcc).

filter_foldl(Fun, Acc, [Head|Tail]) ->
    case Fun(Head, Acc) of
        {HeadItems, HeadAcc} when is_list(HeadItems) ->
            {TailItems, TailAcc} = filter_foldl(Fun, HeadAcc, Tail),
            {HeadItems ++ TailItems, TailAcc};
        Other ->
            throw({error, {"Fun must return a list", Other}})
    end;
filter_foldl(_Fun, Acc, []) ->
    {[], Acc}.
