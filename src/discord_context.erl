-module(discord_context).

-export([user_id/1]).

-spec user_id(Context) -> UserId when
      Context :: discord_gateway:context(),
      UserId  :: binary().
user_id(#{user := #{<<"user">> := #{<<"id">> := UserId}}}) -> UserId;
user_id(#{user := #{<<"id">> := UserId}}) -> UserId.
