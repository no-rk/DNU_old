# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  is_draw = false
  $('#map_tool tr').click ->
    $('#map_tool tr').removeClass('selected')
    $(this).addClass('selected')
  $('#map').mousedown ->
    is_draw = true
  $('#map').mouseup ->
    is_draw = false
  $('#map td').hover ->
    if is_draw
      $(this).removeClass()
      tip_class = $('#map_tool tr.selected').attr('id')
      $(this).addClass(tip_class)