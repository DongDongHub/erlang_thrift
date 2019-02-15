-module(thrift_handle).
-behaviour(gen_server).

-include("exampleService_thrift.hrl").
%% API.
-export([start_link/0,
	invoke/1]).

%% gen_server.
-export([init/1]).
-export([handle_call/3]).
-export([handle_cast/2]).
-export([handle_info/2]).
-export([terminate/2]).
-export([code_change/3]).

-record(state, {id = 1}).

%% API.

-spec start_link() -> {ok, pid()}.
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

invoke(MSG) -> 
	gen_server:call(?MODULE, {thrift, {MSG}}).

%% gen_server.

init([]) ->
	{ok, #state{}}.

handle_call({thrift, {MSG}}, _From, #state{id=ID} = State) -> 
        io:format("get thrift cli ID :~p, MSG : ~p~n", [ID, MSG]),
	Port = 9090,
	{ok, _Client} = thrift_client_util:new("192.168.33.10", Port, exampleService_thrift, []),
	Req = #message{id=ID, text= MSG},
	{_Client2, _Rsp} = case thrift_client:call(_Client, hello, [Req])  of 
		{_Client1, {ok, _Val}} ->
                       io:format("thrift client invoke return Ret ok Val: ~p~n", [_Val]),
			{_Client1, {ok, _Val}}; 
		{_Client1, {error, _Reason}} ->
                       io:format("thrift client invoke return Ret err ok Val: ~p~n", [_Reason]),
			{_Client1, {err, _Reason}} 
	end,
	thrift_client:close(_Client2),
	{reply, {ok, thrift,{_Rsp}}, State#state{id = ID + 1}};
handle_call(_Request, _From, State) ->
	{reply, ignored, State}.

handle_cast(_Msg, State) ->
	{noreply, State}.

handle_info(_Info, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.


