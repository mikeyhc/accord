-module(discord_heartbeat).

-export([start/1, stop/1]).

-spec start(non_neg_integer()) -> {ok, timer:tref()}.
start(IV) ->
    CallerPid = self(),
    Fun = fun() -> CallerPid ! heartbeat end,
    timer:apply_interval(IV, Fun).

-spec stop(timer:tref()) -> ok.
stop(Ref) ->
    {ok, cancel} = timer:cancel(Ref),
    ok.
