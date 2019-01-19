-module(web0_hdlr_api0).

-export([init/2]).

init(R, S) ->
    Method = get_method(cowboy_req:method(R)),
    APIPath = get_path(cowboy_req:path_info(R)),
    Headers0 = maps:to_list(cowboy_req:headers(R)),
    Headers = lists:map(fun({K, V}) -> {binary_to_list(K), binary_to_list(V)} end, Headers0),
    forward(Method, APIPath, Headers, R, S).

forward(get, APIPath, Headers, R, S) -> forward_get(APIPath, Headers, R, S);
forward(post, APIPath, Headers, R, S) -> forward_post(APIPath, Headers, R, S).

forward_get(APIPath, Headers, R0, S) ->
    ReqIn = {mk_url(APIPath), Headers},
    io:format("~npath ~p~n", [APIPath]),
    {ok, {{_, CodeOut, _}, HeadersOut, BodyOut}} = httpc:request(get, ReqIn, [{timeout, 100}], []),
    R1 = cowboy_req:reply(CodeOut, maps:from_list(HeadersOut), BodyOut, R0),
    {ok, R1, S}.

forward_post(APIPath, Headers, R0, S) ->
    {ok, BodyIn, R1} = read_body(R0, S),
    ReqIn = {mk_url(APIPath), Headers, "", BodyIn},
    {ok, {{_, CodeOut, _}, HeadersOut, BodyOut}} = httpc:request(post, ReqIn, [{timeout, 100}], []),
    R1 = cowboy_req:reply(CodeOut, maps:from_list(HeadersOut), BodyOut, R0),
    {ok, R1, S}.

get_method(<<"GET">>) -> get;
get_method(<<"POST">>) -> post.

get_path(PL0) when is_list(PL0) -> 
    PL1 = lists:map(fun(P) -> binary_to_list(P) end, PL0),
    lists:join("/", PL1).

mk_url(P) -> "http://api0:8000/api0/" ++ P.

read_body(Req0, Acc) ->
    case cowboy_req:read_body(Req0) of
        {ok, Data, Req} -> {ok, << Acc/binary, Data/binary >>, Req};
        {more, Data, Req} -> read_body(Req, << Acc/binary, Data/binary >>)
    end.

