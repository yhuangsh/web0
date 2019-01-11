-module(web0_main).
-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_cast/2, handle_call/3]).

-define(MNESIA_DATA, "/deploy/web0/mnesia-data").

%% ========================
%% APIs implementation
%% ========================
start_link() -> 
    gen_server:start_link({local, ?MODULE}, ?MODULE, state0(), []).

%% ========================
%% Callbacks implementation
%% ========================
init(State0 = #{routes := Routes}) ->
    connect_prev_node(node()),
    start_mnesia(),
    start_cowboy(Routes), 
    {ok, State0}.

handle_call(_Cmd, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(_Cmd, State) ->
    {noreply, State}.

%% ========================
%% Internal functions
%% ========================

%% TODO: only works for web0-x, where 0 <= x <= 9
connect_prev_node(N) when is_atom(N) -> connect_prev_node(atom_to_list(N));
connect_prev_node([$a,$p,$p,$@,$w,$e,$b,$0,$-, N | _]) -> connect_prev_node(N);
connect_prev_node($0) -> ok;
connect_prev_node(N) when is_integer(N) ->    
    N0 = ["app@web0-", N-1, ".web0.default.svc.cluster.local"],
    N1 = list_to_atom(lists:flatten(N0)),
    pong = net_adm:ping(N1).

start_mnesia() ->
    ok.

start_cowboy(Routes) ->
    Dispatch = cowboy_router:compile(Routes),
    {ok, _} = cowboy:start_clear(web0_listner, [{port, 7000}], #{env => #{dispatch => Dispatch}}).

state0() -> #{routes => routes()}.

routes() -> [route0()].
route0() -> {'_', [{prefix("/"), web0_hdlr_index, []},
                   {prefix("/dumpreq"), web0_hdlr_dumpreq, []},
                   {'_', web0_hdlr_404, []}]}.

prefix(Path) -> application:get_env(web0, prefix, "") ++ Path.