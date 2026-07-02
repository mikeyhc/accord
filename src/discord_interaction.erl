-module(discord_interaction).

-include("discord_message_flags.hrl").

-export([reply/2, component_reply/2, modal_reply/4, update/2, pong/1]).

-define(DICT_PONG, 1).
-define(DICT_CHANNEL_MESSAGE_WITH_SOURCE, 4).
-define(DICT_DEFERRED_CHANNEL_MESSAGE_WITH_SOURCE, 5).
-define(DICT_DEFERRED_UPDATE_MESSAGE, 6).
-define(DICT_UPDATE_MESSAGE, 7).
-define(DICT_APPLICATION_COMMAND_AUTOCOMPLETE_RESULT, 8).
-define(DICT_MODAL, 9).
-define(DICT_PREMIUM_REQUIRED, 10).
-define(DICT_LAUNCH_ACTIVITY, 12).

-define(DEFAULT_FLAGS, (?DMF_EPHEMERAL)).

-spec reply(Msg, Context) -> ok when
      Msg :: binary(),
      Context :: discord_context:context().
reply(Msg, Context) ->
    Body = #{
             content => Msg,
             flags => ?DEFAULT_FLAGS
            },
    send_interaction_reply(Body, Context).

-spec component_reply(Components, Context) -> ok when
      Components :: [discord_ui:discord_component()],
      Context :: discord_context:context().
component_reply(Components, Context) ->
    Body = #{
             components => Components,
             flags => ?DEFAULT_FLAGS bor ?DMF_IS_COMPONENTS_V2
            },
    send_interaction_reply(Body, Context).

-spec modal_reply(Id, Title, Components, Context) -> ok when
      Id :: binary(),
      Title :: binary(),
      Components :: [discord_ui:discord_component()],
      Context :: discord_context:context().
modal_reply(Id, Title, Components, Context) ->
    Reply = #{type => ?DICT_MODAL,
              data => #{custom_id => Id,
                        title => Title,
                        components => Components}},
    discord_api:interaction_callback(Reply, Context).

-spec update(Components, Context) -> ok when
      Components :: [discord_ui:discord_component()],
      Context :: discord_context:context().
update(Msg, Context) ->
    Update = #{
               type => ?DICT_UPDATE_MESSAGE,
               data => #{
                   components => Msg,
                   flags => ?DEFAULT_FLAGS bor ?DMF_IS_COMPONENTS_V2
               }
              },
    discord_api:interaction_callback(Update, Context).

-spec pong(Context) -> ok when
      Context :: discord_context:context().
pong(Context) ->
    Pong = #{type => ?DICT_DEFERRED_UPDATE_MESSAGE},
    discord_api:interaction_callback(Pong, Context).

% helper functions

send_interaction_reply(Msg, Context) ->
    Reply = #{
              type => ?DICT_CHANNEL_MESSAGE_WITH_SOURCE,
              data => Msg
             },
    discord_api:interaction_callback(Reply, Context).
