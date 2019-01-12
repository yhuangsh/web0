-module(web0_main).
-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_cast/2, handle_call/3]).

-define(MNESIA_DATA, "/deploy/web0/mnesia-data").
-define(SESSION_TAB, session).

%%====================================================================
%% APIs
%%====================================================================

start_link() -> 
    gen_server:start_link({local, ?MODULE}, ?MODULE, state0(), []).

%%====================================================================
%% Callbacks
%%====================================================================

init(S0) ->
    Np = connect_prev_node(node()),
    ok = mnesia:start(),
    {atomic, ok} = start_mnesia(Np),
    start_cowboy(S0), 
    {ok, S0}.

handle_call(_Cmd, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(_Cmd, State) ->
    {noreply, State}.

%%====================================================================
%% Internal functions
%%====================================================================

%% TODO: only works for web0-x, where 0 <= x <= 9
connect_prev_node(N) when is_atom(N) -> connect_prev_node(atom_to_list(N));
connect_prev_node([$a,$p,$p,$@,$w,$e,$b,$0,$-, N | _]) -> connect_prev_node(N);
connect_prev_node($0) -> none;
connect_prev_node(N) when is_integer(N) ->    
    Np0 = ["app@web0-", N-1, ".web0.default.svc.cluster.local"],
    Np1 = list_to_atom(lists:flatten(Np0)),
    pong = net_adm:ping(Np1),
    Np1.

%%
start_mnesia(none) -> {atomic, ok} = mnesia:create_table(?SESSION_TAB, []);
start_mnesia(Np) when is_atom(Np) ->
    {ok, _} = mnesia:change_config(extra_db_nodes, [Np]),
    {atomic, ok} = mnesia:add_table_copy(?SESSION_TAB, node(), ram_copies).

%%
start_cowboy(S0) ->
    Dispatch = cowboy_router:compile(routes(S0)),
    {ok, _} = cowboy:start_clear(web0_listner, [{port, 7000}], #{env => #{dispatch => Dispatch}}).

routes(S0) -> [route0(S0)].
route0(S0) -> {'_', [{prefix("/"), web0_hdlr_index, S0},
                     {prefix("/cookie/:cmd/[:newsid]"), web0_hdlr_cookie, S0},
                     {prefix("/probes/:pb"), web0_hdlr_probes, S0},
                     {prefix("/dumpreq"), web0_hdlr_dumpreq, S0},
                     {'_', web0_hdlr_404, []}]}.                

prefix(Path) -> application:get_env(web0, prefix, "") ++ Path.

state0() -> #{}.

