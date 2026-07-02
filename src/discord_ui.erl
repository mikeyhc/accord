-module(discord_ui).

-export([action_row/1, button/2, string_select/2, string_select/3,
         text_display/1, label/2, component_type_id_to_atom/1, select_option/2,
         select_option/3]).

-export_type([discord_modal/0, discord_component/0,
              discord_select_option/0, discord_button_options/0,
              discord_component_type/0]).

% component types
-define(ACTION_ROW, 1).
-define(BUTTON, 2).
-define(STRING_SELECT, 3).
-define(TEXT_INPUT, 4).
-define(USER_SELECT, 5).
-define(ROLE_SELECT, 6).
-define(MENTIONABLE_SELECT, 7).
-define(CHANNEL_SELECT, 8).
-define(SECTION, 9).
-define(TEXT_DISPLAY, 10).
-define(THUMBNAIL, 11).
-define(MEDIA_GALLERY, 12).
-define(D_FILE, 13).
-define(SEPARATOR, 14).
-define(CONTAINER, 17).
-define(LABEL, 18).
-define(FILE_UPLOAD, 19).
-define(RADIO_GROUP, 21).
-define(CHECKBOX_GROUP, 22).
-define(CHECKBOX, 23).

-type discord_component() :: #{type := non_neg_integer(),
                               atom() => any()}.
-type discord_modal() :: #{atom() => any()}.
-type discord_select_option() :: #{label := binary(),
                                   value := binary(),
                                   emoji => binary(),
                                   default => boolean(),
                                   description => binary()
                                  }.
-type discord_button_options() :: #{disabled => boolean()}.
-type discord_component_type() :: action_row | button | string_select |
                                  text_input | user_select | role_select |
                                  mentionable_select | channeL_select |
                                  section | text_display | thumbnail |
                                  media_gallery | file | separator |
                                  container | label | file_upload |
                                  radio_group | checkbox_group | checkbox.
-type discord_component_id() :: ?ACTION_ROW | ?BUTTON | ?STRING_SELECT |
                                ?TEXT_INPUT | ?USER_SELECT | ?ROLE_SELECT |
                                ?MENTIONABLE_SELECT | ?CHANNEL_SELECT |
                                ?SECTION | ?TEXT_DISPLAY | ?THUMBNAIL |
                                ?MEDIA_GALLERY | ?D_FILE | ?SEPARATOR |
                                ?CONTAINER | ?LABEL | ?FILE_UPLOAD |
                                ?RADIO_GROUP | ?CHECKBOX_GROUP | ?CHECKBOX.
-type discord_button_style() :: primary | secondary | success | danger | link |
                                premium.
-type discord_emoji() :: #{id := null | binary(),
                           name := null | binary(),
                           roles => binary(),
                           user => #{any() => any()},
                           require_colons => boolean(),
                           managed => boolean(),
                           animated => boolean(),
                           available => boolean()}.

% component functions
-spec action_row([discord_component()]) -> discord_component().
action_row(Components) ->
    #{type => ?ACTION_ROW,
      components => Components
     }.

-spec button(Style, Options) -> discord_component() when
      Style :: discord_button_style(),
      Options :: #{id => non_neg_integer(),
                   label => binary(),
                   emoji => discord_emoji(),
                   custom_id => binary(),
                   sku_id => binary(),
                   url => binary(),
                   disabled => boolean()}.
button(Style, Options) ->
    Base = #{type => ?BUTTON,
              style => Style
             },
    maps:merge(Options, Base).

-spec string_select(Id, Options) -> discord_component() when
      Id :: binary(),
      Options :: [discord_select_option()].
string_select(Id, Options) -> string_select(Id, Options, #{}).

-spec string_select(Id, Options, SelectOptions) -> discord_component() when
      Id :: binary(),
      Options :: [discord_select_option()],
      SelectOptions :: #{id => binary(),
                         placeholder => binary(),
                         min_values => 0..25,
                         max_values => 1..25,
                         required => boolean(),
                         disabled => boolean()}.
string_select(Id, Options, SelectOptions) ->
    Base =#{type => ?STRING_SELECT,
            custom_id => Id,
            options => Options
           },
    maps:merge(SelectOptions, Base).

-spec text_display(binary()) -> discord_component().
text_display(Content) ->
    #{type => ?TEXT_DISPLAY,
      content => Content
     }.

-spec label(binary(), discord_component()) -> discord_component().
label(Text, Component) ->
    #{type => ?LABEL,
      label => Text,
      component => Component
     }.

-spec component_type_id_to_atom(discord_component_id()) ->
    discord_component_type().
component_type_id_to_atom(?ACTION_ROW) -> action_row;
component_type_id_to_atom(?BUTTON) -> button;
component_type_id_to_atom(?STRING_SELECT) -> string_select;
component_type_id_to_atom(?TEXT_INPUT) -> text_input;
component_type_id_to_atom(?USER_SELECT) -> user_select;
component_type_id_to_atom(?ROLE_SELECT) -> role_select;
component_type_id_to_atom(?MENTIONABLE_SELECT) -> mentionable_select;
component_type_id_to_atom(?CHANNEL_SELECT) -> channeL_select;
component_type_id_to_atom(?SECTION) -> section;
component_type_id_to_atom(?TEXT_DISPLAY) -> text_display;
component_type_id_to_atom(?THUMBNAIL) -> thumbnail;
component_type_id_to_atom(?MEDIA_GALLERY) -> media_gallery;
component_type_id_to_atom(?D_FILE) -> file;
component_type_id_to_atom(?SEPARATOR) -> separator;
component_type_id_to_atom(?CONTAINER) -> container;
component_type_id_to_atom(?LABEL) -> label;
component_type_id_to_atom(?FILE_UPLOAD) -> file_upload;
component_type_id_to_atom(?RADIO_GROUP) -> radio_group;
component_type_id_to_atom(?CHECKBOX_GROUP) -> checkbox_group;
component_type_id_to_atom(?CHECKBOX) -> checkbox.

-spec select_option(Label, Value) -> discord_select_option() when
      Label :: binary(),
      Value :: binary().
select_option(Label, Value) -> select_option(Label, Value, #{}).

-spec select_option(Label, Value, Options) -> discord_select_option() when
      Label :: binary(),
      Value :: binary(),
      Options :: #{emoji => discord_emoji(),
                   default => boolean(),
                   description => binary()
                  }.
select_option(Label, Value, Options) ->
    maps:merge(Options, #{label => Label, value => Value}).
