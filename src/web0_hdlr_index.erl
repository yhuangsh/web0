-module(web0_hdlr_index).

-export([init/2]).

init(Req0, State) ->
    Req = cowboy_req:reply(200, content_type(), hello_msg(), Req0),
    {ok, Req, State}.

content_type() -> #{<<"content-type">> => <<"text/text">>}.

hello_msg() ->
    ["Hello from web0 app in Erlang with Cowboy, served from: \n",
     "this node=", atom_to_list(node()), "\n",
     "connected nodes=[", mk_list(nodes()), "]\n"].

mk_list(L) ->
    lists:join(",", lists:map(fun(N) -> atom_to_list(N) end, L)).