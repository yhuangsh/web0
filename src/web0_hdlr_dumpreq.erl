-module(web0_hdlr_dumpreq).

-export([init/2]).

init(Req0, State) ->
    Req = cowboy_req:reply(200, content_type(), dumpreq(Req0), Req0),
    {ok, Req, State}.

content_type() -> #{<<"content-type">> => <<"text/text">>}.

dumpreq(#{headers := Headers}) ->
    io_lib:format("~p", [Headers]).