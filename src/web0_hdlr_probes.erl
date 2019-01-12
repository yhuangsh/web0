-module(web0_hdlr_probes).

-export([init/2]).

init(R0, S0) ->
    Probe = cowboy_req:binding(pb, R0),
    handle_probe(Probe, R0, S0).

handle_probe(undefined, R, S) -> web0_hdlr_common:'404'(R, S);
handle_probe(<<"live">>, R, S) -> web0_hdlr_common:'200'(R,S);
handle_probe(<<"ready">>, R, S) -> web0_hdlr_common:'200'(R, S).
