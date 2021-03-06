%%
%% %CopyrightBegin%
%%
%% Copyright Ericsson AB 1998-2009. All Rights Reserved.
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
-module(mnesia_late_loader).

-export([
	 async_late_disc_load/3,
	 maybe_async_late_disc_load/3,
	 init/1,
	 start/0
	]).

%% sys callback functions
-export([
	 system_continue/3,
	 system_terminate/4,
	 system_code_change/4
	]).

-define(SERVER_NAME, ?MODULE).

-record(state, {supervisor}).

async_late_disc_load(_, [], _) -> ok;
async_late_disc_load(Node, Tabs, Reason) ->
    Msg = {async_late_disc_load, Tabs, Reason},
    catch ({?SERVER_NAME, Node} ! {self(), Msg}).

maybe_async_late_disc_load(_, [], _) -> ok;
maybe_async_late_disc_load(Node, Tabs, Reason) ->
    Msg = {maybe_async_late_disc_load, Tabs, Reason},
    catch ({?SERVER_NAME, Node} ! {self(), Msg}).

start() ->
    mnesia_monitor:start_proc(?SERVER_NAME, ?MODULE, init, [self()]).

init(Parent) ->
    %% Trap exit omitted intentionally
    register(?SERVER_NAME, self()),
    link(whereis(mnesia_controller)),  %% We may not hang
		%% 同步schema表
    mnesia_controller:merge_schema(),
    unlink(whereis(mnesia_controller)),
		%% 成功后设置mnesia_status为running
		%% 只有这步骤成功才代表mnesia启动成功
    mnesia_lib:set(mnesia_status, running),
    proc_lib:init_ack(Parent, {ok, self()}),
    loop(#state{supervisor = Parent}).

loop(State) ->
    receive
	{_From, {async_late_disc_load, Tabs, Reason}} ->
	    mnesia_controller:schedule_late_disc_load(Tabs, Reason),
	    loop(State);

	{_From, {maybe_async_late_disc_load, Tabs, Reason}} ->
	    CheckMaster =
		fun(Tab, Good) ->
			case mnesia_recover:get_master_nodes(Tab) of
			    [] -> [Tab|Good];
			    Masters ->
				case lists:member(node(),Masters) of
				    true -> [Tab|Good];
				    false -> Good
				end
			end
		end,
	    GoodTabs = lists:foldl(CheckMaster, [], Tabs),
	    mnesia_controller:schedule_late_disc_load(GoodTabs, Reason),
	    loop(State);

	{system, From, Msg} ->
	    mnesia_lib:dbg_out("~p got {system, ~p, ~p}~n",
			       [?SERVER_NAME, From, Msg]),
	    Parent = State#state.supervisor,
	    sys:handle_system_msg(Msg, From, Parent, ?MODULE, [], State);

	Msg ->
	    mnesia_lib:error("~p got unexpected message: ~p~n",
			     [?SERVER_NAME, Msg]),
	    loop(State)
    end.

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% System upgrade

system_continue(_Parent, _Debug, State) ->
    loop(State).

system_terminate(Reason, _Parent, _Debug, _State) ->
    exit(Reason).

system_code_change(State, _Module, _OldVsn, _Extra) ->
    {ok, State}.
