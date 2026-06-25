-module(discord_context).

-export([new/1, user_id/1, itoken/1]).
-export_type([context/0]).

-record(discord_itoken, {id    :: binary(),
                         token :: binary()
                        }).

-record(discord_context, {itoken :: #discord_itoken{},
                          user   :: json(),
                          d      :: json()
                         }).

-opaque context() :: #discord_context{}.
-type json() :: #{binary() => any()}.

-spec new(DiscordData) -> Result when
      DiscordData :: json(),
      Result :: {ok, context()} | {error, Error},
      Error :: no_user_data.
new(D=#{<<"id">> := InteractionId,
        <<"token">> := InteractionToken
       }) ->
    MaybeUser = case maps:get(<<"member">>, D, undefined) of
                    undefined ->
                        case maps:get(<<"user">>, D, undefined) of
                            undefined -> {error, no_user_data};
                            UserEntry -> {ok, UserEntry}
                        end;
                    Member -> Member
                end,
    case MaybeUser of
        {ok, User} ->
            IToken = #discord_itoken{id=InteractionId, token=InteractionToken},
            {ok, #discord_context{user=User, itoken=IToken, d=D}};
        Error -> Error
    end.


-spec user_id(Context) -> UserId when
      Context :: context(),
      UserId  :: binary().
user_id(#discord_context{user=#{<<"user">> := #{<<"id">> := UserId}}}) ->
    UserId;
user_id(#discord_context{user=#{<<"id">> := UserId}}) -> UserId.

-spec itoken(Context) -> {InteractionId, InteractionToken} when
      Context :: context(),
      InteractionId :: binary(),
      InteractionToken :: binary().
itoken(#discord_context{itoken=#discord_itoken{id=Id, token=Token}}) ->
    {Id, Token}.
