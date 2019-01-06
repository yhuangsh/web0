-module(web0_hdlr_dumpreq).

-export([init/2]).

init(Req0, State) ->
    Req = cowboy_req:reply(200, content_type(), dumpreq(Req0), Req0),
    {ok, Req, State}.

content_type() -> #{<<"content-type">> => <<"text/text">>}.

dumpreq(#{headers := Headers, host := Host, method := Method, path := Path}) ->
    J0 = Headers,
    J1 = J0#{<<"pased_host">> => Host, 
             <<"parsed_method">> => Method,
             <<"parsed_path">> => Path},
    jsx:prettify(jsx:encode(J1)).