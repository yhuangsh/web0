-module(web0_hdlr_common).

-export(['400'/3, '404'/2, '200'/2, '200'/3]).

-define(CT_TEXT, <<"content-type">> => <<"text/text">>).

%%====================================================================
%% API
%%====================================================================

'200'(R, S) -> reply(200, R, S).
'200'(T, R, S) -> reply(200, T, R, S).
'400'(T, R, S) -> reply(400, T, R, S).
'404'(R, S) -> reply(404, R, <<"web0: ooops, not found!">>, S).

reply(C, R, S) -> {ok, cowboy_req:reply(C, R), S}.
reply(C, T, R, S) -> {ok, cowboy_req:reply(C, #{?CT_TEXT}, T, R), S}.
