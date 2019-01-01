-module(web0_handler).

-export([init/2]).

init(Req0, State) ->
    Req = cowboy_req:reply(200, content_type(), hello_msg(), Req0),
    {ok, Req, State}.

content_type() -> #{<<"content-type">> => <<"text/html">>}.

hello_msg() ->
    {ok, Hostname} = inet:gethostname(),
    [<<"<html><body><h1>Hello from web0 app in Erlang with Cowboy, served from node">>,
     <<"<pre>">>, Hostname, <<"</pre></h1><body></html>">>].