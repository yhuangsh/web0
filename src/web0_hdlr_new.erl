-module(web0_hdlr_new).

-export([init/2]).

init(R0, S0) ->
    _D0 = cowboy_req:binding(data, R0),
    web0_hdlr_common:'200'(R0, <<"todo">>, S0).

