-module(web0_hdlr_session).

-export([init/2]).

init(R, S) ->
    Cmd = cowboy_req:binding(cmd, R),
    Data = cowboy_req:binding(data, R),
    #{sid := OldSid} = cowboy_req:match_cookies([{sid, [], undefined}], R),
    handle_cookie(Cmd, OldSid, Data, R, S).

handle_cookie(<<"new">>, _, Data, R, S) -> handle_cookie_new(gen_svr_sid(), Data, R, S);
handle_cookie(<<"show">>, OldSid, _, R, S) -> handle_cookie_show(OldSid, R, S).

%% 
handle_cookie_new(_, undefined, R, S) -> web0_hdlr_common:'400'([msg_this_node(), "session data missing"], R, S);
handle_cookie_new(NewSid, Data, R0, S) -> 
    NewData = #{data => Data},
    {atomic, ok} = mnesia:transaction(fun() -> mnesia:write({session, NewSid, NewData}) end),
    R1 = cowboy_req:set_resp_cookie(<<"sid">>, NewSid, R0, cookie_opts()),
    web0_hdlr_common:'200'(msg_new_session(NewSid, NewData), R1, S).

gen_svr_sid() -> base64:encode(crypto:strong_rand_bytes(32)).

cookie_opts() ->
    #{max_age => 3600,
      domain => "dev.davidhuang.top",
      path => "/web0",
      secure => true,
      http_only => true}.

%%
handle_cookie_show(undefined, R, S) -> web0_hdlr_common:'200'("no session id provided", R, S);
handle_cookie_show(OldSid, R, S) ->    
    Data = mnesia:dirty_read({session, OldSid}),
    handle_cookie_show(OldSid, Data, R, S).
handle_cookie_show(Sid, [], R, S) -> web0_hdlr_common:'200'(["session id ", Sid, " does not exist"], R, S);
handle_cookie_show(Sid, [{session, _, D}], R, S) -> web0_hdlr_common:'200'(msg_old_session(Sid, D), R, S).

%%
msg_this_node() -> ["this node = ", atom_to_list(node()), "\n"].

msg_new_session(S, D) -> msg_session("new session: ", S, D).
msg_old_session(S, D) -> msg_session("existing session: ", S, D).

msg_session(T, S, D) -> [T, "\n",
                         "session id = ", S, "\n",
                         "session data = ", fmt(D), "\n"].

fmt(T) -> io_lib:format("~p", [T]).

