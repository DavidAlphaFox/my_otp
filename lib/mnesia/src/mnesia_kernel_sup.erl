%%
%% %CopyrightBegin%
%%
%% Copyright Ericsson AB 1997-2009. All Rights Reserved.
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
-module(mnesia_kernel_sup).

-behaviour(supervisor).

-export([start/0, init/1, supervisor_timeout/1]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% top supervisor callback functions

start() ->
    supervisor:start_link({local, mnesia_kernel_sup}, ?MODULE, []).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sub supervisor callback functions
%mnesia的关键进程
init([]) ->
    ProcLib = [mnesia_monitor, proc_lib],
    Flags = {one_for_all, 0, timer:hours(24)}, % Trust the top supervisor
    %% 最先启动的是mnesia_monitor
    %% mnesia_monitor持有mnesia_gvar和mnesia_stats两张ets表
    %% mnesia的全局变量全都保存在此处
    Workers = [worker_spec(mnesia_monitor, timer:seconds(3), [gen_server]),
        %% mnesia_subscr 创建订阅管理进程
        %% 自动将mnesia_event加入到系统订阅表中
	       worker_spec(mnesia_subscr, timer:seconds(3), [gen_server]),
        %% mnesia的锁管理进程
	       worker_spec(mnesia_locker, timer:seconds(3), ProcLib),
         %% mnesia恢复进程
	       worker_spec(mnesia_recover, timer:minutes(3), [gen_server]),
         %% mnesia事务进程
	       worker_spec(mnesia_tm, timer:seconds(30), ProcLib),
         %% 检察点监控者进程
	       supervisor_spec(mnesia_checkpoint_sup),
         %% snmp监控者进程
	       supervisor_spec(mnesia_snmp_sup),
         %% mnesia主控进程
	       worker_spec(mnesia_controller, timer:seconds(3), [gen_server]),
         %% mnesia数据加载进程
	       worker_spec(mnesia_late_loader, timer:seconds(3), ProcLib)
	      ],
    {ok, {Flags, Workers}}.

worker_spec(Name, KillAfter, Modules) ->
    KA = supervisor_timeout(KillAfter),
    {Name, {Name, start, []}, permanent, KA, worker, [Name] ++ Modules}.

supervisor_spec(Name) ->
    {Name, {Name, start, []}, permanent, infinity, supervisor,
     [Name, supervisor]}.

-ifdef(debug_shutdown).
supervisor_timeout(_KillAfter) -> timer:hours(24).
-else.
supervisor_timeout(KillAfter) -> KillAfter.
-endif.
