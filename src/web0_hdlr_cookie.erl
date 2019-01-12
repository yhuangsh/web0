-module(web0_hdlr_cookie).

-export([init/2]).

init(R, S) ->
    Cmd = cowboy_req:binding(cmd, R),
    NewSid = cowboy_req:binding(newsid, R),
    #{sid := OldSid} = cowboy_req:match_cookies([{sid, [], undefined}], R),
    handle_cookie(Cmd, OldSid, NewSid, R, S).

handle_cookie(<<"new">>, OldSid, NewSid, R, S) -> handle_cookie_new(OldSid, NewSid, R, S);
handle_cookie(<<"show">>, OldSid, _, R, S) -> web0_hdlr_common:'200'(R, msg(OldSid, undefined), S).

handle_cookie_new(OldSid, undefined, R, S) -> web0_hdlr_common:'200'(R, msg(OldSid, undefined), S);
handle_cookie_new(OldSid, <<"server">>, R, S) -> handle_cookie_new(OldSid, gen_svr_sid(), R, S);
handle_cookie_new(OldSid, NewSid, R0, S) -> 
    R1 = cowboy_req:set_resp_cookie(<<"sid">>, NewSid, R0, cookie_opts()),
    web0_hdlr_common:'200'(R1, msg(OldSid, NewSid), S).

gen_svr_sid() -> "server-gen-" ++ base64:encode(crypto:strong_rand_bytes(32)).

msg(undefined, Sn) -> msg("undefined", Sn);
msg(So, undefined) -> msg(So, "undefined");
msg(So, Sn) ->
    ["this node = ", atom_to_list(node()), "\n",
     "old session id = ", So, "\n",
     "new session id = ", Sn, "\n"].

cookie_opts() ->
    #{max_age => 3600,
      domain => "dev.davidhuang.top",
      path => "/web0",
      secure => true,
      http_only => true}.