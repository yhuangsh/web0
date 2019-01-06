-module(web0_hdlr_404).

-export([init/2]).

init(Req0, State) ->
    Req = cowboy_req:reply(200, content_type(), errmsg404(), Req0),
    {ok, Req, State}.

content_type() -> #{<<"content-type">> => <<"text/text">>}.

errmsg404() -> <<"web0: Ops, 404!">>.