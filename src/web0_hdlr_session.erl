-module(web0_hdlr_session).

-export([init/2]).

init(R, S) ->
    Cmd = cowboy_req:binding(cmd, R),
    #{sid := OldSid} = cowboy_req:match_cookies([{sid, [], undefined}], R),
    handle_cookie(Cmd, OldSid, R, S).

handle_cookie(<<"new">>, OldSid, R, S) -> handle_cookie_new(OldSid, gen_svr_sid(), R, S);
handle_cookie(<<"show">>, OldSid, R, S) -> web0_hdlr_common:'200'(R, msg(OldSid, undefined), S).

handle_cookie_new(OldSid, NewSid, R0, S) -> 
    R1 = cowboy_req:set_resp_cookie(<<"sid">>, NewSid, R0, cookie_opts()),
    web0_hdlr_common:'200'(R1, msg(OldSid, NewSid), S).

gen_svr_sid() -> base64:encode(crypto:strong_rand_bytes(32)).

msg(undefined, undefined) -> [msg_this_node(), "no session at all\n"];
msg(undefined, Sn) -> [msg_this_node(), "new session id = ", Sn, "\n"];
msg(So, undefined) -> [msg_this_node(), "current session id = ", So, "\n"];
msg(So, Sn) -> [msg_this_node(), "current session id = ", So, "\nnew session id = ", Sn, "\n"].

msg_this_node() -> ["this node = ", atom_to_list(node()), "\n"].

cookie_opts() ->
    #{max_age => 3600,
      domain => "dev.davidhuang.top",
      path => "/web0",
      secure => true,
      http_only => true}.