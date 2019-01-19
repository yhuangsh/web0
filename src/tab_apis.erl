-module(tab_apis).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-export([create_table/0,
         add_table_copy/0,

         create/1,
         read/1, 
         read_path/1,
         update/1,
         update_overwrite/1,
         delete/1,
         
         load_from_env/0]).

-record(apis, {id, path, endpoint, options, more}).

-define(TAB_APIS, apis).

%%====================================================================
%% API
%%====================================================================

%% Bootstrap
create_table() -> 
    mnesia:create_table(?TAB_APIS, 
                        [{attributes, record_info(fields, ?TAB_APIS)},
                         {index, [path]},
                         {disc_copies, [node()]}]).
add_table_copy() ->
    mnesia:add_table_copy(?TAB_APIS, node(), disc_copies).

%% CRUD
create(U = #apis{id = Id}) -> 
    mnesia:transaction(
        fun() -> 
            case mnesia:read(?TAB_APIS, Id) of
                [] -> mnesia:write(U);
                [_] -> exists
            end
        end).
read(Id) -> mnesia:dirty_read(?TAB_APIS, Id).
read_path(Path) -> mnesia:dirty_index_read(?TAB_APIS, Path, #apis.path).
update(U = #apis{id = Id}) -> 
    mnesia:transaction(
        fun() ->
            case mnesia:read(?TAB_APIS, Id) of 
                [_] -> mnesia:write(U);
                [] -> not_exist
            end
        end).
update_overwrite(U) -> mnesia:transaction(fun() -> mnesia:write(U) end).
delete(Id) -> mnesia:transaction(fun() -> mnesia:delete({?TAB_APIS, Id}) end).

%% 
load_from_env() ->
    ok.

%%====================================================================
%% Unit tests
%%====================================================================

-ifdef(TEST).

crud_test_() ->
    {setup, fun setup/0, fun cleanup/1, 
     fun (D) ->
        [test_create(D),
         test_read(D),
         test_update(D),
         test_delete(D)] 
     end}.

setup() ->
    mnesia:delete_schema([node()]),
    ok = mnesia:create_schema([node()]),
    ok = mnesia:start(),
    {atomic, ok} = create_table(),
    A0 = #apis{id = api0000, path = "api0", endpoint = "http://api0:8000/api0"},
    A1 = #apis{id = api0001},
    A0new = #apis{id = api0000, path = "api1", endpoint = "http://api1:8000/api1"},
    {U0, U1, U0new}.

cleanup(_) -> 
    ?assertEqual({atomic, ok}, mnesia:delete_table(?TAB_APIS)),
    ?assertEqual(stopped, mnesia:stop()).

test_create({A0, _A1, _A0new}) ->    
    [?_assertEqual({atomic, ok}, create(A0)),
     ?_assertEqual({atomic, exists}, create(A0))].

test_read({A0, _A1, _A0new}) ->
    [?_assertEqual([A0], read(api0000)),
     ?_assertEqual([A0], read_path("api0")),
     ?_assertEqual([], read(api0001)),
     ?_assertEqual([], read_path("api1"))].

test_update({A0, A1, A0new}) ->
    [?_assertEqual({atomic, ok}, update(A0)),
     ?_assertEqual({atomic, not_exist}, update(A1)),
     ?_assertEqual({atomic, ok}, update(A0new)),
     ?_assertEqual([U0new], read(api0000)),
     ?_assertEqual([U0new], read_path("api1"))].

test_delete({_A0, _A1, _A0new}) ->
    [?_assertEqual({atomic, ok}, delete(api0000)),
     ?_assertEqual([], read(api0000)),
     ?_assertEqual([], read_path("api0"))].

-endif.