# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  goal_input = '.goal_input'
  $(goal_input).focus () -> $(this).addClass 'selected'
  $(goal_input).focusout () -> $(this).removeClass 'selected'
  $(goal_input).on 'input', () ->
    value = $(this).val()
    opposite_value = if value >= 8 then parseInt(value) + 2 else 10
    $(goal_input).not('.selected').val opposite_value

