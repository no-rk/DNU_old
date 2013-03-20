# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  is_draw   = false
  is_vision = false
  $.fn.drawMap = () ->
    map_tip       = $('#map_tool tr.selected').attr('id')
    map_collision = $('#map_tool tr.selected').find(':checkbox').is(':checked')
    map_opacity   = $('#map_tool tr.selected').find('input[type=number]').val()
    $(this).removeClass()
    $(this).addClass(map_tip)
    $(this).data('map_collision', map_collision)
    $(this).data('map_opacity', map_opacity)
  $.fn.aroundMap = (next_vision) ->
    arrounds = []
    col = $("td",$(this).parent('tr')).index(this)
    t_map = $(this).parent('tr').prev('tr').children('td:nth-child('+(col+1)+')')
    r_map = $(this).next('td')
    b_map = $(this).parent('tr').next('tr').children('td:nth-child('+(col+1)+')')
    l_map = $(this).prev('td')
    if (t_map.data('map_vision') || 0) <= next_vision
      arrounds.push(t_map)
    if (r_map.data('map_vision') || 0) <= next_vision
      arrounds.push(r_map)
    if (b_map.data('map_vision') || 0) <= next_vision
      arrounds.push(b_map)
    if (l_map.data('map_vision') || 0) <= next_vision
      arrounds.push(l_map)
    arrounds
  $('#map_tool tr').click ->
    $('#map_tool tr').removeClass('selected')
    $(this).addClass('selected')
  $('#map').mousedown ->
    is_draw = true
  $('#map').mouseup ->
    is_draw = false
  $('#map td').click ->
    $(this).drawMap()
  $('#map td').hover ->
    if is_draw
      $(this).drawMap()
    if is_vision
      #count = 0
      enlighten = ($center, vision, map_opacity = $center.data('map_opacity') || 0) ->
        $center.data('map_vision', vision)
        $center.addClass('enlighten')
        next_vision = vision - 1 - map_opacity
        if next_vision >= 0
          $.each $center.aroundMap(next_vision), (i, $place) ->
            #count++
            enlighten($place, next_vision)
      enlighten($(this), $('#vision_size').val(), 0)
      #console.log(count)
  , ->
    $('#map td').removeClass('enlighten')
    $('#map td').removeData('map_vision')
  $('#map_vision').click ->
    if is_vision
      $(this).text('視界表示オフ')
      is_vision = false
    else
      $(this).text('視界表示オン')
      is_vision = true
