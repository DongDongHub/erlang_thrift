-module(erl_sample_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
   	Thrift = {thrift_handle, {thrift_handle, start_link, []},permanent, 2000, worker, [thrift_handle]},
	Procs = [Thrift],
	%%Procs = [],
	{ok, {{one_for_one, 0, 1}, Procs}}.
