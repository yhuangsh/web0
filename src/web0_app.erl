%%%-------------------------------------------------------------------
%% @doc web0 public API
%% @end
%%%-------------------------------------------------------------------

-module(web0_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    {ok, _} = application:ensure_all_started(cowboy),
    {ok, _} = application:ensure_all_started(inets),
    {ok, _} = init(),
    web0_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================

init() ->
    Np = connect_prev_node(node()),
    {atomic, ok} = start_mnesia_init_tab(Np),
    {ok, _} = start_cowboy(state0()).

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
start_mnesia_init_tab(none) -> 
    CreateSchemaRet = mnesia:create_schema([node()]),
    ok = mnesia:start(),
    init_tab_0(CreateSchemaRet);
start_mnesia_init_tab(Np) when is_atom(Np) ->
    ok = mnesia:start(),
    SchemaStorageType0 = mnesia:table_info(schema, storage_type),
    add_this_node(SchemaStorageType0, Np),
    SchemaStorageType1 = mnesia:table_info(schema, storage_type),
    init_tab_n(SchemaStorageType1).

init_tab_0(ok) -> {atomic, ok} = tab_apis:create_table();
init_tab_0({error, {_,{already_exists, _}}}) -> {atomic, ok}.

add_this_node(ram_copies, Np) -> {ok, _} = mnesia:change_config(extra_db_nodes, [Np]);
add_this_node(disc_copies, _) -> {ok, ignored}.

init_tab_n(ram_copies) -> 
    {atomic, ok} = mnesia:change_table_copy_type(schema, node(), disc_copies),
    {atomic, ok} = tab_apis:add_table_copy();
init_tab_n(disc_copies) -> {atomic, ok}.

%%
start_cowboy(S) ->
    Dispatch = cowboy_router:compile(routes(S)),
    {ok, _} = cowboy:start_clear(web0_listner, [{port, 7000}], #{env => #{dispatch => Dispatch}}).

routes(S) -> [route0(S)].
route0(S) -> {'_', [{prefix("/"), web0_hdlr_index, S},
                     {prefix("/api0/[...]"), web0_hdlr_api0, S},
                     {prefix("/session/:cmd/[:data]"), web0_hdlr_session, S},
                     {prefix("/probes/:pb"), web0_hdlr_probes, S},
                     {prefix("/dumpreq"), web0_hdlr_dumpreq, S},
                     {'_', web0_hdlr_404, []}]}.                

prefix(Path) -> application:get_env(web0, prefix, "") ++ Path.

state0() -> #{}.