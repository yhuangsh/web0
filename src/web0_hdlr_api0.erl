-module(web0_hdlr_api0).
-include("./tab_apis.hrl").

-export([init/2]).

init(R, S) ->
    API = binary_to_atom(cowboy_req:binding(api, R), latin1),
    forward(tab_apis:read(API), R, S).

forward([], R, S) -> httpres:'404'(R, S);
forward([#api{endpoint = Endpoint}], R, S) ->

    Method = cowboy_req:method(R),
    APIUrl = get_url(Endpoint, cowboy_req:path_info(R)),
    Headers0 = maps:to_list(cowboy_req:headers(R)),
    Headers = lists:map(fun({K, V}) -> {binary_to_list(K), binary_to_list(V)} end, Headers0),
    forward(Method, APIUrl, Headers, R, S).

forward(<<"GET">>, APIUrl, Headers, R0, S) -> 
    ReqIn = {APIUrl, Headers},
    io:format("~npath ~s~n", [APIUrl]),
    {ok, {{_, CodeOut, _}, HeadersOut, BodyOut}} = httpc:request(get, ReqIn, [{timeout, 100}], []),
    R1 = cowboy_req:reply(CodeOut, maps:from_list(HeadersOut), BodyOut, R0),
    {ok, R1, S}; 
forward(<<"POST">>, APIUrl, Headers, R0, S) -> 
    {ok, BodyIn, R1} = read_body(R0, S),
    ReqIn = {APIUrl, Headers, "", BodyIn},
    {ok, {{_, CodeOut, _}, HeadersOut, BodyOut}} = httpc:request(post, ReqIn, [{timeout, 100}], []),
    R1 = cowboy_req:reply(CodeOut, maps:from_list(HeadersOut), BodyOut, R0),
    {ok, R1, S}.

get_url(Ep, PathList) when is_list(Ep) andalso is_list(PathList) -> 
    PL1 = lists:map(fun(P) -> binary_to_list(P) end, PathList),
    Ep ++ [$/ | lists:join("/", PL1)].

read_body(Req0, Acc) ->
    case cowboy_req:read_body(Req0) of
        {ok, Data, Req} -> {ok, << Acc/binary, Data/binary >>, Req};
        {more, Data, Req} -> read_body(Req, << Acc/binary, Data/binary >>)
    end.

