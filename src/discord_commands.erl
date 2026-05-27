-module(discord_commands).

-export([command/3, subcommand_group/3, subcommand/2, subcommand/3]).
-export([string_input/3, boolean_input/2, boolean_input/3]).
-export_type([command/0, subcommand_group/0, subcommand/0, input/0,
              input_options/0]).

-define(SUBCOMMAND_TYPE, 1).
-define(SUBCOMMAND_GROUP_TYPE, 2).
-define(STRING_INPUT_TYPE, 3).
-define(INTEGER_INPUT_TYPE, 4).
-define(BOOLEAN_INPUT_TYPE, 5).

-opaque input() :: #{name => binary(),
                     description => binary(),
                     type => pos_integer(),
                     required => boolean()
                    }.
-opaque subcommand() :: #{name => binary(),
                          description => binary(),
                          type => ?SUBCOMMAND_TYPE,
                          options => [input()]
                         }.
-opaque subcommand_group() :: #{name => binary(),
                                description => binary(),
                                type => ?SUBCOMMAND_GROUP_TYPE,
                                options => [subcommand()]
                               }.
-opaque command() :: #{name => binary(),
                       description => binary(),
                       options => [subcommand_group()]
                      }.

-type input_options() :: #{required => boolean()}.

-spec command(binary(), binary(), [subcommand_group()]) -> command().
command(Name, Description, Options) ->
    #{name => Name,
      description => Description,
      options => Options
     }.

-spec subcommand_group(binary(), binary(), [subcommand()]) ->
    subcommand_group().
subcommand_group(Name, Description, Options) ->
    #{name => Name,
      description => Description,
      type => ?SUBCOMMAND_GROUP_TYPE,
      options => Options
     }.

-spec subcommand(binary(), binary()) -> subcommand().
subcommand(Name, Description) ->
    #{name => Name,
      description => Description,
      type => ?SUBCOMMAND_TYPE
     }.

-spec subcommand(binary(), binary(), [input()]) -> subcommand().
subcommand(Name, Description, Options) ->
    #{name => Name,
      description => Description,
      type => ?SUBCOMMAND_TYPE,
      options => Options
     }.

-spec string_input(binary(), binary(), input_options()) -> input().
string_input(Name, Description, Options) ->
    build_input(?STRING_INPUT_TYPE, Name, Description, Options).

-spec boolean_input(binary(), binary()) -> input().
boolean_input(Name, Description) ->
    boolean_input(Name, Description, #{}).

-spec boolean_input(binary(), binary(), input_options()) -> input().
boolean_input(Name, Description, Options) ->
    build_input(?BOOLEAN_INPUT_TYPE,  Name, Description, Options).

% helper functions

build_input(Type, Name, Description, Options) ->
    Required = maps:get(required, Options, false),
    #{name => Name,
      description => Description,
      type => Type,
      required => Required
     }.
