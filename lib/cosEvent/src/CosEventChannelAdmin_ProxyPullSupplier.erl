%%  coding: latin-1
%%------------------------------------------------------------
%%
%% Implementation stub file
%% 
%% Target: CosEventChannelAdmin_ProxyPullSupplier
%% Source: /Users/david/Documents/workspace/my_otp/lib/cosEvent/src/CosEventChannelAdmin.idl
%% IC vsn: 4.3.6
%% 
%% This file is automatically generated. DO NOT EDIT IT.
%%
%%------------------------------------------------------------

-module('CosEventChannelAdmin_ProxyPullSupplier').
-ic_compiled("4_3_6").


%% Interface functions
-export([connect_pull_consumer/2, connect_pull_consumer/3]).

%% Exports from "CosEventComm::PullSupplier"
-export([pull/1, pull/2, try_pull/1]).
-export([try_pull/2, disconnect_pull_supplier/1, disconnect_pull_supplier/2]).

%% Type identification function
-export([typeID/0]).

%% Used to start server
-export([oe_create/0, oe_create_link/0, oe_create/1]).
-export([oe_create_link/1, oe_create/2, oe_create_link/2]).

%% TypeCode Functions and inheritance
-export([oe_tc/1, oe_is_a/1, oe_get_interface/0]).

%% gen server export stuff
-behaviour(gen_server).
-export([init/1, terminate/2, handle_call/3]).
-export([handle_cast/2, handle_info/2, code_change/3]).

-include_lib("orber/include/corba.hrl").


%%------------------------------------------------------------
%%
%% Object interface functions.
%%
%%------------------------------------------------------------



%%%% Operation: connect_pull_consumer
%% 
%%   Returns: RetVal
%%   Raises:  CosEventChannelAdmin::AlreadyConnected
%%
connect_pull_consumer(OE_THIS, Pull_consumer) ->
    corba:call(OE_THIS, connect_pull_consumer, [Pull_consumer], ?MODULE).

connect_pull_consumer(OE_THIS, OE_Options, Pull_consumer) ->
    corba:call(OE_THIS, connect_pull_consumer, [Pull_consumer], ?MODULE, OE_Options).

%%%% Operation: pull
%% 
%%   Returns: RetVal
%%   Raises:  CosEventComm::Disconnected
%%
pull(OE_THIS) ->
    corba:call(OE_THIS, pull, [], ?MODULE).

pull(OE_THIS, OE_Options) ->
    corba:call(OE_THIS, pull, [], ?MODULE, OE_Options).

%%%% Operation: try_pull
%% 
%%   Returns: RetVal, Has_event
%%   Raises:  CosEventComm::Disconnected
%%
try_pull(OE_THIS) ->
    corba:call(OE_THIS, try_pull, [], ?MODULE).

try_pull(OE_THIS, OE_Options) ->
    corba:call(OE_THIS, try_pull, [], ?MODULE, OE_Options).

%%%% Operation: disconnect_pull_supplier
%% 
%%   Returns: RetVal
%%
disconnect_pull_supplier(OE_THIS) ->
    corba:call(OE_THIS, disconnect_pull_supplier, [], ?MODULE).

disconnect_pull_supplier(OE_THIS, OE_Options) ->
    corba:call(OE_THIS, disconnect_pull_supplier, [], ?MODULE, OE_Options).

%%------------------------------------------------------------
%%
%% Inherited Interfaces
%%
%%------------------------------------------------------------
oe_is_a("IDL:omg.org/CosEventChannelAdmin/ProxyPullSupplier:1.0") -> true;
oe_is_a("IDL:omg.org/CosEventComm/PullSupplier:1.0") -> true;
oe_is_a(_) -> false.

%%------------------------------------------------------------
%%
%% Interface TypeCode
%%
%%------------------------------------------------------------
oe_tc(connect_pull_consumer) -> 
	{tk_void,[{tk_objref,"IDL:omg.org/CosEventComm/PullConsumer:1.0",
                             "PullConsumer"}],
                 []};
oe_tc(pull) -> 'CosEventComm_PullSupplier':oe_tc(pull);
oe_tc(try_pull) -> 'CosEventComm_PullSupplier':oe_tc(try_pull);
oe_tc(disconnect_pull_supplier) -> 'CosEventComm_PullSupplier':oe_tc(disconnect_pull_supplier);
oe_tc(_) -> undefined.

oe_get_interface() -> 
	[{"disconnect_pull_supplier", 'CosEventComm_PullSupplier':oe_tc(disconnect_pull_supplier)},
	{"try_pull", 'CosEventComm_PullSupplier':oe_tc(try_pull)},
	{"pull", 'CosEventComm_PullSupplier':oe_tc(pull)},
	{"connect_pull_consumer", oe_tc(connect_pull_consumer)}].




%%------------------------------------------------------------
%%
%% Object server implementation.
%%
%%------------------------------------------------------------


%%------------------------------------------------------------
%%
%% Function for fetching the interface type ID.
%%
%%------------------------------------------------------------

typeID() ->
    "IDL:omg.org/CosEventChannelAdmin/ProxyPullSupplier:1.0".


%%------------------------------------------------------------
%%
%% Object creation functions.
%%
%%------------------------------------------------------------

oe_create() ->
    corba:create(?MODULE, "IDL:omg.org/CosEventChannelAdmin/ProxyPullSupplier:1.0").

oe_create_link() ->
    corba:create_link(?MODULE, "IDL:omg.org/CosEventChannelAdmin/ProxyPullSupplier:1.0").

oe_create(Env) ->
    corba:create(?MODULE, "IDL:omg.org/CosEventChannelAdmin/ProxyPullSupplier:1.0", Env).

oe_create_link(Env) ->
    corba:create_link(?MODULE, "IDL:omg.org/CosEventChannelAdmin/ProxyPullSupplier:1.0", Env).

oe_create(Env, RegName) ->
    corba:create(?MODULE, "IDL:omg.org/CosEventChannelAdmin/ProxyPullSupplier:1.0", Env, RegName).

oe_create_link(Env, RegName) ->
    corba:create_link(?MODULE, "IDL:omg.org/CosEventChannelAdmin/ProxyPullSupplier:1.0", Env, RegName).

%%------------------------------------------------------------
%%
%% Init & terminate functions.
%%
%%------------------------------------------------------------

init(Env) ->
%% Call to implementation init
    corba:handle_init('CosEventChannelAdmin_ProxyPullSupplier_impl', Env).

terminate(Reason, State) ->
    corba:handle_terminate('CosEventChannelAdmin_ProxyPullSupplier_impl', Reason, State).


%%%% Operation: connect_pull_consumer
%% 
%%   Returns: RetVal
%%   Raises:  CosEventChannelAdmin::AlreadyConnected
%%
handle_call({_, OE_Context, connect_pull_consumer, [Pull_consumer]}, _, OE_State) ->
  corba:handle_call('CosEventChannelAdmin_ProxyPullSupplier_impl', connect_pull_consumer, [Pull_consumer], OE_State, OE_Context, false, false);

%%%% Operation: pull
%% 
%%   Returns: RetVal
%%   Raises:  CosEventComm::Disconnected
%%
handle_call({_, OE_Context, pull, []}, _, OE_State) ->
  corba:handle_call('CosEventChannelAdmin_ProxyPullSupplier_impl', pull, [], OE_State, OE_Context, false, false);

%%%% Operation: try_pull
%% 
%%   Returns: RetVal, Has_event
%%   Raises:  CosEventComm::Disconnected
%%
handle_call({_, OE_Context, try_pull, []}, _, OE_State) ->
  corba:handle_call('CosEventChannelAdmin_ProxyPullSupplier_impl', try_pull, [], OE_State, OE_Context, false, false);

%%%% Operation: disconnect_pull_supplier
%% 
%%   Returns: RetVal
%%
handle_call({_, OE_Context, disconnect_pull_supplier, []}, _, OE_State) ->
  corba:handle_call('CosEventChannelAdmin_ProxyPullSupplier_impl', disconnect_pull_supplier, [], OE_State, OE_Context, false, false);



%%%% Standard gen_server call handle
%%
handle_call(stop, _, State) ->
    {stop, normal, ok, State};

handle_call(_, _, State) ->
    {reply, catch corba:raise(#'BAD_OPERATION'{minor=1163001857, completion_status='COMPLETED_NO'}), State}.


%%%% Standard gen_server cast handle
%%
handle_cast(stop, State) ->
    {stop, normal, State};

handle_cast(_, State) ->
    {noreply, State}.


%%%% Standard gen_server handles
%%
handle_info(_, State) ->
    {noreply, State}.


code_change(OldVsn, State, Extra) ->
    corba:handle_code_change('CosEventChannelAdmin_ProxyPullSupplier_impl', OldVsn, State, Extra).

