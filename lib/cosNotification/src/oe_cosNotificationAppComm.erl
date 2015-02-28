%%  coding: latin-1
%%------------------------------------------------------------
%%
%% Implementation stub file
%% 
%% Target: oe_cosNotificationAppComm
%% Source: /Users/david/Documents/workspace/my_otp/lib/cosNotification/src/cosNotificationAppComm.idl
%% IC vsn: 4.3.6
%% 
%% This file is automatically generated. DO NOT EDIT IT.
%%
%%------------------------------------------------------------

-module(oe_cosNotificationAppComm).
-ic_compiled("4_3_6").


-include_lib("orber/include/ifr_types.hrl").

%% Interface functions

-export([oe_register/0, oe_unregister/0, oe_get_module/5]).
-export([oe_dependency/0]).



oe_register() ->
    OE_IFR = orber_ifr:find_repository(),

    register_tests(OE_IFR),

    _OE_1 = oe_get_top_module(OE_IFR, "IDL:oe_CosNotificationComm:1.0", "oe_CosNotificationComm", "1.0"),

    _OE_2 = orber_ifr:'ModuleDef_create_interface'(_OE_1, "IDL:oe_CosNotificationComm/Event:1.0", "Event", "1.0", []),

    orber_ifr:'InterfaceDef_create_enum'(_OE_2, "IDL:oe_CosNotificationComm/Event/status:1.0", "status", "1.0", ["MATCH","MATCHED"]),

    orber_ifr:'InterfaceDef_create_operation'(_OE_2, "IDL:oe_CosNotificationComm/Event/callSeq:1.0", "callSeq", "1.0", orber_ifr:'Repository_create_idltype'(OE_IFR, tk_void), 'OP_NORMAL', [#parameterdescription{name="stat", type={tk_enum,
                                         "IDL:oe_CosNotificationComm/Event/status:1.0",
                                         "status",
                                         ["MATCH","MATCHED"]}, type_def=orber_ifr:'Repository_create_idltype'(OE_IFR, {tk_enum,
                                               "IDL:oe_CosNotificationComm/Event/status:1.0",
                                               "status",
                                               ["MATCH","MATCHED"]}), mode='PARAM_IN'}
, #parameterdescription{name="events", type={tk_sequence,
                                           {tk_struct,
                                            "IDL:omg.org/CosNotification/StructuredEvent:1.0",
                                            "StructuredEvent",
                                            [{"header",
                                              {tk_struct,
                                               "IDL:omg.org/CosNotification/EventHeader:1.0",
                                               "EventHeader",
                                               [{"fixed_header",
                                                 {tk_struct,
                                                  "IDL:omg.org/CosNotification/FixedEventHeader:1.0",
                                                  "FixedEventHeader",
                                                  [{"event_type",
                                                    {tk_struct,
                                                     "IDL:omg.org/CosNotification/EventType:1.0",
                                                     "EventType",
                                                     [{"domain_name",
                                                       {tk_string,0}},
                                                      {"type_name",
                                                       {tk_string,0}}]}},
                                                   {"event_name",
                                                    {tk_string,0}}]}},
                                                {"variable_header",
                                                 {tk_sequence,
                                                  {tk_struct,
                                                   "IDL:omg.org/CosNotification/Property:1.0",
                                                   "Property",
                                                   [{"name",{tk_string,0}},
                                                    {"value",tk_any}]},
                                                  0}}]}},
                                             {"filterable_data",
                                              {tk_sequence,
                                               {tk_struct,
                                                "IDL:omg.org/CosNotification/Property:1.0",
                                                "Property",
                                                [{"name",{tk_string,0}},
                                                 {"value",tk_any}]},
                                               0}},
                                             {"remainder_of_body",tk_any}]},
                                           0}, type_def=orber_ifr:'Repository_create_idltype'(OE_IFR, {tk_sequence,
                                               {tk_struct,
                                                "IDL:omg.org/CosNotification/StructuredEvent:1.0",
                                                "StructuredEvent",
                                                [{"header",
                                                  {tk_struct,
                                                   "IDL:omg.org/CosNotification/EventHeader:1.0",
                                                   "EventHeader",
                                                   [{"fixed_header",
                                                     {tk_struct,
                                                      "IDL:omg.org/CosNotification/FixedEventHeader:1.0",
                                                      "FixedEventHeader",
                                                      [{"event_type",
                                                        {tk_struct,
                                                         "IDL:omg.org/CosNotification/EventType:1.0",
                                                         "EventType",
                                                         [{"domain_name",
                                                           {tk_string,0}},
                                                          {"type_name",
                                                           {tk_string,0}}]}},
                                                       {"event_name",
                                                        {tk_string,0}}]}},
                                                    {"variable_header",
                                                     {tk_sequence,
                                                      {tk_struct,
                                                       "IDL:omg.org/CosNotification/Property:1.0",
                                                       "Property",
                                                       [{"name",{tk_string,0}},
                                                        {"value",tk_any}]},
                                                      0}}]}},
                                                 {"filterable_data",
                                                  {tk_sequence,
                                                   {tk_struct,
                                                    "IDL:omg.org/CosNotification/Property:1.0",
                                                    "Property",
                                                    [{"name",{tk_string,0}},
                                                     {"value",tk_any}]},
                                                   0}},
                                                 {"remainder_of_body",
                                                  tk_any}]},
                                               0}), mode='PARAM_IN'}
], [], []),

    orber_ifr:'InterfaceDef_create_operation'(_OE_2, "IDL:oe_CosNotificationComm/Event/callAny:1.0", "callAny", "1.0", orber_ifr:'Repository_create_idltype'(OE_IFR, tk_void), 'OP_NORMAL', [#parameterdescription{name="stat", type={tk_enum,
                                         "IDL:oe_CosNotificationComm/Event/status:1.0",
                                         "status",
                                         ["MATCH","MATCHED"]}, type_def=orber_ifr:'Repository_create_idltype'(OE_IFR, {tk_enum,
                                               "IDL:oe_CosNotificationComm/Event/status:1.0",
                                               "status",
                                               ["MATCH","MATCHED"]}), mode='PARAM_IN'}
, #parameterdescription{name="event", type=tk_any, type_def=orber_ifr:'Repository_create_idltype'(OE_IFR, tk_any), mode='PARAM_IN'}
], [], []),

    ok.


%% General IFR registration checks.
register_tests(OE_IFR)->
  re_register_test(OE_IFR),
  include_reg_test(OE_IFR).


%% IFR type Re-registration checks.
re_register_test(OE_IFR)->
  case orber_ifr:'Repository_lookup_id'(OE_IFR,"IDL:oe_CosNotificationComm/Event:1.0") of
    []  ->
      true;
    _ ->
      exit({allready_registered,"IDL:oe_CosNotificationComm/Event:1.0"})
 end.


%% IFR registration checks for included idl files.
include_reg_test(OE_IFR) ->
  case orber_ifr:'Repository_lookup_id'(OE_IFR,"IDL:omg.org/CosEventComm:1.0") of
    [] ->
      exit({unregistered,"IDL:omg.org/CosEventComm:1.0"});
    _  ->
      true
  end,
  case orber_ifr:'Repository_lookup_id'(OE_IFR,"IDL:omg.org/CosEventChannelAdmin:1.0") of
    [] ->
      exit({unregistered,"IDL:omg.org/CosEventChannelAdmin:1.0"});
    _  ->
      true
  end,
  case orber_ifr:'Repository_lookup_id'(OE_IFR,"IDL:omg.org/CosNotification:1.0") of
    [] ->
      exit({unregistered,"IDL:omg.org/CosNotification:1.0"});
    _  ->
      true
  end,
  true.


%% Fetch top module reference, register if unregistered.
oe_get_top_module(OE_IFR, ID, Name, Version) ->
  case orber_ifr:'Repository_lookup_id'(OE_IFR, ID) of
    [] ->
      orber_ifr:'Repository_create_module'(OE_IFR, ID, Name, Version);
    Mod  ->
      Mod
   end.

%% Fetch module reference, register if unregistered.
oe_get_module(OE_IFR, OE_Parent, ID, Name, Version) ->
  case orber_ifr:'Repository_lookup_id'(OE_IFR, ID) of
    [] ->
      orber_ifr:'ModuleDef_create_module'(OE_Parent, ID, Name, Version);
    Mod  ->
      Mod
   end.



oe_unregister() ->
    OE_IFR = orber_ifr:find_repository(),

    oe_destroy(OE_IFR, "IDL:oe_CosNotificationComm/Event:1.0"),
    oe_destroy_if_empty(OE_IFR, "IDL:oe_CosNotificationComm:1.0"),
    ok.


oe_destroy_if_empty(OE_IFR,IFR_ID) ->
    case orber_ifr:'Repository_lookup_id'(OE_IFR, IFR_ID) of
	[] ->
	    ok;
	Ref ->
	    case orber_ifr:contents(Ref, 'dk_All', 'true') of
		[] ->
		    orber_ifr:destroy(Ref),
		    ok;
		_ ->
		    ok
	    end
    end.

oe_destroy(OE_IFR,IFR_ID) ->
    case orber_ifr:'Repository_lookup_id'(OE_IFR, IFR_ID) of
	[] ->
	    ok;
	Ref ->
	    orber_ifr:destroy(Ref),
	    ok
    end.



%% Idl file dependency list function
oe_dependency() ->

    {"/Users/david/Documents/workspace/my_otp/lib/cosNotification/src/cosNotificationAppComm.idl",
     ["/Users/david/Documents/workspace/my_otp/lib/cosEvent/src/CosEventComm.idl",
      "/Users/david/Documents/workspace/my_otp/lib/cosEvent/src/CosEventChannelAdmin.idl",
      "CosNotification.idl"]}.

