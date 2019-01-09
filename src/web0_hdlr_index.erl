-module(web0_hdlr_index).

-export([init/2]).

init(Req0, State) ->
    Req = cowboy_req:reply(200, content_type(), hello_msg(), Req0),
    {ok, Req, State}.

content_type() -> #{<<"content-type">> => <<"text/text">>}.

hello_msg() ->
    {ok, Hostname} = inet:gethostname(),
    ["Hello from web0 app in Erlang with Cowboy, served from: \n",
     "hostname=", Hostname, "\n",
     "node=", atom_to_list(node()), "\n",
     "cookie=", atom_to_list(erlang:get_cookie()), "\n"].