-module(web0_hdlr_index).

-export([init/2]).

init(Req0, State) ->
    Req = cowboy_req:reply(200, content_type(), hello_msg(), Req0),
    {ok, Req, State}.

content_type() -> #{<<"content-type">> => <<"text/text">>}.

hello_msg() ->
    P1 = net_adm:ping('web0@web0-1.web0.default.svc.cluster.local'),
    P2 = net_adm:ping('web0@web0-2.web0.default.svc.cluster.local'),
    P3 = net_adm:ping('web0@web0-3.web0.default.svc.cluster.local'),
    {ok, Hostname} = inet:gethostname(),
    ["Hello from web0 app in Erlang with Cowboy, served from: \n",
     "hostname=", Hostname, "\n",
     "node=", atom_to_list(node()), "\n",
     "pinging nodes=[", lists:map(fun(N) -> atom_to_list(N) end, [P1, P2, P3]), "]\n",
     "connected nodes=[", lists:map(fun(N) -> atom_to_list(N) end, nodes()), "]\n"].