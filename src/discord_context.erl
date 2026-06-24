-module(discord_context).

-include("accord_context.hrl").

-export([user_id/1]).
-export_type([context/0]).

-opaque context() :: #accord_context{}.

-spec user_id(Context) -> UserId when
      Context :: context(),
      UserId  :: binary().
user_id(#accord_context{user=#{<<"user">> := #{<<"id">> := UserId}}}) -> UserId;
user_id(#accord_context{user=#{<<"id">> := UserId}}) -> UserId.
