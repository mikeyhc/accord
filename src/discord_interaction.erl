-module(discord_interaction).

-include("discord_interaction_types.hrl").
-include("discord_message_flags.hrl").

-export([reply/2, component_reply/2, update/2, pong/1]).

-define(DEFAULT_FLAGS, (?DMF_EPHEMERAL)).

-spec reply(Msg, Context) -> ok when
      Msg :: binary(),
      Context :: discord_gateway:context().
reply(Msg, Context) ->
    Body = #{
             content => Msg,
             flags => ?DEFAULT_FLAGS
            },
    send_interaction_reply_(Body, Context).

-spec component_reply(Components, Context) -> ok when
      Components :: [discord_ui:discord_component()],
      Context :: discord_gateway:context().
component_reply(Components, Context) ->
    Body = #{
             components => Components,
             flags => ?DEFAULT_FLAGS bor ?DMF_IS_COMPONENTS_V2
            },
    send_interaction_reply_(Body, Context).

-spec update(Components, Context) -> ok when
      Components :: [discord_ui:discord_component()],
      Context :: discord_gateway:context().
update(Msg, #{itoken := #{interaction_id := InteractionId,
                          interaction_token := InteractionToken
                         }}) ->
    Update = #{
               type => ?DICT_UPDATE_MESSAGE,
               data => #{
                   components => Msg,
                   flags => ?DEFAULT_FLAGS bor ?DMF_IS_COMPONENTS_V2
               }
              },
    discord_api:interaction_callback(
      InteractionId,
      InteractionToken,
      Update
     ).


-spec pong(Context) -> ok when
      Context :: discord_gateway:context().
pong(#{itoken := #{interaction_id := InteractionId,
                   interaction_token := InteractionToken
                  }}) ->
    Pong = #{type => ?DICT_DEFERRED_UPDATE_MESSAGE},
    discord_api:interaction_callback(
      InteractionId,
      InteractionToken,
      Pong
     ).

% helper functions

send_interaction_reply_(Msg,
                        #{itoken :=
                          #{interaction_id := InteractionId,
                            interaction_token := InteractionToken}}) ->
    Reply = #{
              type => ?DICT_CHANNEL_MESSAGE_WITH_SOURCE,
              data => Msg
             },
    discord_api:interaction_callback(
      InteractionId,
      InteractionToken,
      Reply
     ).
