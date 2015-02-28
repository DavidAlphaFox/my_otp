%%  coding: latin-1
%%------------------------------------------------------------
%%
%% Implementation stub file
%% 
%% Target: CosTransactions_TransIdentity
%% Source: /Users/david/Documents/workspace/my_otp/lib/cosTransactions/src/CosTransactions.idl
%% IC vsn: 4.3.6
%% 
%% This file is automatically generated. DO NOT EDIT IT.
%%
%%------------------------------------------------------------

-module('CosTransactions_TransIdentity').
-ic_compiled("4_3_6").


-include("CosTransactions.hrl").

-export([tc/0,id/0,name/0]).



%% returns type code
tc() -> {tk_struct,"IDL:omg.org/CosTransactions/TransIdentity:1.0",
                   "TransIdentity",
                   [{"coord",
                     {tk_objref,"IDL:omg.org/CosTransactions/Coordinator:1.0",
                                "Coordinator"}},
                    {"term",
                     {tk_objref,"IDL:omg.org/CosTransactions/Terminator:1.0",
                                "Terminator"}},
                    {"otid",
                     {tk_struct,"IDL:omg.org/CosTransactions/otid_t:1.0",
                                "otid_t",
                                [{"formatID",tk_long},
                                 {"bqual_length",tk_long},
                                 {"tid",{tk_sequence,tk_octet,0}}]}}]}.

%% returns id
id() -> "IDL:omg.org/CosTransactions/TransIdentity:1.0".

%% returns name
name() -> "CosTransactions_TransIdentity".



