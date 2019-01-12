-module(web0_hdlr_dumpreq).

-export([init/2]).

init(R0, S0) ->
    R1 = cowboy_req:reply(200, content_type(), dumpreq(R0), R0),
    {ok, R1, S0}.

content_type() -> #{<<"content-type">> => <<"text/text">>}.

dumpreq(#{headers := Headers, host := Host, method := Method, path := Path}) ->
    J0 = Headers,
    J1 = J0#{<<"_host">> => Host, 
             <<"_method">> => Method,
             <<"_path">> => Path},
    jsx:prettify(jsx:encode(J1)).