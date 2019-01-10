-module(web0_hdlr_index).

-export([init/2]).

init(Req0, State) ->
    Req = cowboy_req:reply(200, content_type(), hello_msg(), Req0),
    {ok, Req, State}.

content_type() -> #{<<"content-type">> => <<"text/text">>}.

hello_msg() ->
    P1 = net_adm:ping('app@web0-0.web0'),
    P2 = net_adm:ping('app@web0-1.web0'),
    P3 = net_adm:ping('app@web0-2.web0'),
    {ok, Hostname} = inet:gethostname(),
    ["Hello from web0 app in Erlang with Cowboy, served from: \n",
     "hostname=", Hostname, "\n",
     "node=", atom_to_list(node()), "\n",
     "pinging nodes=[", mk_list([P1, P2, P3]), "]\n",
     "connected nodes=[", mk_list(nodes()), "]\n"].

mk_list(L) ->
    lists:join(",", lists:map(fun(N) -> atom_to_list(N) end, L)).