-module(web0_main).
-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_cast/2, handle_call/3]).

%% ========================
%% APIs implementation
%% ========================
start_link() -> 
    gen_server:start_link({local, ?MODULE}, ?MODULE, state0(), []).

%% ========================
%% Callbacks implementation
%% ========================
init(State0 = #{routes := Routes}) ->
    Dispatch = cowboy_router:compile(Routes),
    {ok, _} = cowboy:start_clear(web0_listner, [{port, 7000}], #{env => #{dispatch => Dispatch}}),
    {ok, State0}.

handle_call(_Cmd, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(_Cmd, State) ->
    {noreply, State}.

%% ========================
%% Internal functions
%% ========================
state0() -> #{routes => routes()}.

routes() -> [route0()].
route0() -> {'_', [path0()]}.
path0() -> {'_', web0_handler, []}.
