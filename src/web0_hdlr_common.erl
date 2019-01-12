-module(web0_hdlr_common).

-export(['404'/2, '200'/2, '200'/3]).

-define(CT_TEXT, <<"content-type">> => <<"text/text">>).

%%====================================================================
%% API
%%====================================================================

'404'(R, S) -> {ok, cowboy_req:reply(404, #{?CT_TEXT}, <<"web0: ooops, not found!">>, R), S}.
'200'(R, S) -> {ok, cowboy_req:reply(200, R), S}.
'200'(R, T, S) -> {ok, cowboy_req:reply(200, #{?CT_TEXT}, T, R), S}.

