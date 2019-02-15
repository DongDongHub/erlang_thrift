-module(http_handler).
-behavior(cowboy_handler).

-export([init/2]).


init(Req
, State) ->
	io:format("req ~p~n", [Req]),
	Qs = maps:get(qs, Req, <<"no_field">>),
	_Rsp = thrift_handle:invoke(Qs),
	_Rsp1 = io_lib:format("~p", [_Rsp]),
	Rsp = cowboy_req:reply(200, #{<<"content-type">> => <<"text/plain">>}, _Rsp1, Req),
	{ok, Rsp, State}.
