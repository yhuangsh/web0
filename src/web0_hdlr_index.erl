-module(web0_hdlr_index).

-export([init/2]).

init(R0, S0) ->
    R1 = cowboy_req:reply(200, content_type(), hello_msg(), R0),
    {ok, R1, S0}.

content_type() -> #{<<"content-type">> => <<"text/text">>}.

hello_msg() ->
    ["Hello from web0, a Kubernetes, Erlang, Cowboy experiment\n",
     "version = ", app_vsn(), "\n",
     "this node = ", atom_to_list(node()), "\n",
     "connected nodes = [", mk_list(nodes()), "]\n",
     "mnesia nodes = ", io_lib:format("~p", [mnesia:system_info(db_nodes)]), "\n"].

mk_list(L) ->
    lists:join(",", lists:map(fun(N) -> atom_to_list(N) end, L)).

app_vsn() ->
    Apps = application:which_applications(),
    {web0, _, Version} = lists:keyfind(web0, 1, Apps),
    Version.