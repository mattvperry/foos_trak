# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

goal_input = '.goal_input'
player_input = '.player_input'
match_quality = '.match_quality'

$ ->
  $(goal_input).focus () -> $(this).addClass 'selected'
  $(goal_input).focusout () -> $(this).removeClass 'selected'
  $(goal_input).on 'input', () ->
    value = $(this).val()
    opposite_value = if value >= 8 then parseInt(value) + 2 else 10
    $(goal_input).not('.selected').val opposite_value

  if $(match_quality).length
    $(player_input).change load_match_quality

load_match_quality = () ->
  team1_inputs = '.panel-body:nth(0) ' + player_input
  team2_inputs = '.panel-body:nth(1) ' + player_input
  values_of = (elems) -> ($(elem).val() for elem in elems)
  players = $(player_input + ':has(option[value!=""]:selected)')
  unique_players = $.unique(values_of(players)).length
  num_players = players.length
  if num_players == $(player_input).length && num_players == unique_players
    teams =
      team1ids: values_of $(team1_inputs)
      team2ids: values_of $(team2_inputs)
    $.get '/games/match_quality.json', teams,
      (data) ->
        match_percent = Math.round(parseFloat(data) * 100)
        $(match_quality).text(match_percent + '% match')
