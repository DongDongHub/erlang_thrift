-module(erl_sample_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
	Dispatch = cowboy_router:compile([
			{'_', [{"/", http_handler, []}]}
			]),

	{ok, _} = cowboy:start_clear(my_http_listener, [{port, 8088}], #{env => #{dispatch => Dispatch}}),
	erl_sample_sup:start_link().

stop(_State) ->
	ok.
