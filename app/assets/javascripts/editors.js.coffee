# マップ
$ ->
  is_draw   = false
  is_vision = false
  $.fn.changeTip = (is_recursion) ->
    $map0 = $(this)
    if $map0.is('div')
      map4_class = $map0.data('map4_class')
      map_x = $map0.data('map4_x')
      map_y = $map0.data('map4_y')
      switch map4_class
        when 'map_ur'
          $map1 = $('div#map4_' + (map_x-1) + '_' +  map_y   )
          $map2 = $('div#map4_' + (map_x-1) + '_' + (map_y+1))
          $map3 = $('div#map4_' +  map_x    + '_' + (map_y+1))
        when 'map_lr'
          $map1 = $('div#map4_' +  map_x    + '_' + (map_y+1))
          $map2 = $('div#map4_' + (map_x+1) + '_' + (map_y+1))
          $map3 = $('div#map4_' + (map_x+1) + '_' +  map_y   )
        when 'map_ll'
          $map1 = $('div#map4_' + (map_x+1) + '_' +  map_y   )
          $map2 = $('div#map4_' + (map_x+1) + '_' + (map_y-1))
          $map3 = $('div#map4_' +  map_x    + '_' + (map_y-1))
        when 'map_ul'
          $map1 = $('div#map4_' +  map_x    + '_' + (map_y-1))
          $map2 = $('div#map4_' + (map_x-1) + '_' + (map_y-1))
          $map3 = $('div#map4_' + (map_x-1) + '_' +  map_y   )
      map0 = $map0.parents('td').attr('class')
      map1 = if $map1.is('div') then $map1.parents('td').attr('class') else map0
      map2 = if $map2.is('div') then $map2.parents('td').attr('class') else map0
      map3 = if $map3.is('div') then $map3.parents('td').attr('class') else map0
      tip_number = 0
      if map0!=map1
        tip_number += 1
      if map0!=map3
        tip_number += 2
      if tip_number==0 && map0!=map2
        tip_number = 4
      $(this).removeClass().addClass(map4_class).addClass('map4_tip_' + tip_number)
      if is_recursion
        $map1.changeTip()
        $map2.changeTip()
        $map3.changeTip()
  $.fn.drawMap = () ->
    map_tip       = $('#map_tool tr.selected').attr('id')
    map_collision = $('#map_tool tr.selected').find(':checkbox').is(':checked')
    map_opacity   = $('#map_tool tr.selected').find('input[type=number]').val()
    $(this).removeClass()
    $(this).addClass(map_tip)
    $(this).find('div.map_collision').removeClass('true')
    if map_collision
      $(this).find('div.map_collision').addClass('true')
    if map_opacity > 0
      $(this).find('div.map_opacity').html('<p>' + map_opacity + '</p>')
    else
      $(this).find('div.map_opacity').empty()
    $(this).data('map_collision', map_collision)
    $(this).data('map_opacity', map_opacity)
    $(this).find('div.map_ur').changeTip(true)
    $(this).find('div.map_lr').changeTip(true)
    $(this).find('div.map_ll').changeTip(true)
    $(this).find('div.map_ul').changeTip(true)
  $.fn.aroundMap = (next_vision) ->
    arrounds = []
    map_x = $(this).data('map_x')
    map_y = $(this).data('map_y')
    t_map = $('td#map_' + (map_x-1) + '_' +  map_y   )
    r_map = $('td#map_' +  map_x    + '_' + (map_y+1))
    b_map = $('td#map_' + (map_x+1) + '_' +  map_y   )
    l_map = $('td#map_' +  map_x    + '_' + (map_y-1))
    if t_map.is('td') && (t_map.data('map_vision') ? -1) < next_vision
      arrounds.push(t_map)
    if r_map.is('td') && (r_map.data('map_vision') ? -1) < next_vision
      arrounds.push(r_map)
    if b_map.is('td') && (b_map.data('map_vision') ? -1) < next_vision
      arrounds.push(b_map)
    if l_map.is('td') && (l_map.data('map_vision') ? -1) < next_vision
      arrounds.push(l_map)
    arrounds
  $('#map tr').each (i, tr) ->
    $(tr).children('td').each (j, td) ->
      $(td).attr('id', 'map_' + i + '_' + j)
      $(td).data('map_x', i)
      $(td).data('map_y', j)
      $base      = $('<div>').addClass('map_base')
      $inner     = $('<div>').addClass('map_inner')
      $collision = $('<div>').addClass('map_collision')
      $opacity = $('<div>').addClass('map_opacity')
      $ur = $('<div>').attr('id', 'map4_' +  2*i    + '_' + (2*j+1)).addClass('map_ur map4_tip_0').data('map4_class', 'map_ur').data('map4_x',  2*i   ).data('map4_y', (2*j+1))
      $lr = $('<div>').attr('id', 'map4_' + (2*i+1) + '_' + (2*j+1)).addClass('map_lr map4_tip_0').data('map4_class', 'map_lr').data('map4_x', (2*i+1)).data('map4_y', (2*j+1))
      $ll = $('<div>').attr('id', 'map4_' + (2*i+1) + '_' +  2*j   ).addClass('map_ll map4_tip_0').data('map4_class', 'map_ll').data('map4_x', (2*i+1)).data('map4_y',  2*j   )
      $ul = $('<div>').attr('id', 'map4_' +  2*i    + '_' +  2*j   ).addClass('map_ul map4_tip_0').data('map4_class', 'map_ul').data('map4_x',  2*i   ).data('map4_y',  2*j   )
      $(td).append($base.append($ur).append($lr).append($ll).append($ul).append($inner).append($collision).append($opacity))
  $('#map_tool tr').click ->
    $('#map_tool tr').removeClass('selected')
    $(this).addClass('selected')
  $('#map').mousedown ->
    is_draw = true
  $('#map').mouseup ->
    is_draw = false
  $('#map td').mousedown ->
    $(this).drawMap()
  $('#map td').hover ->
    if is_draw
      $(this).drawMap()
    if is_vision
      enlighten = ($center, vision, map_opacity = $center.data('map_opacity') ? 0) ->
        $center.data('map_vision', vision)
        $center.children('div.map_base').addClass('enlighten')
        next_vision = vision - 1 - map_opacity
        if next_vision >= 0
          $.each $center.aroundMap(next_vision), (i, $place) ->
            enlighten($place, next_vision)
      enlighten($(this), $('#vision_size').val(), 0)
  , ->
    $('#map td div.map_base').removeClass('enlighten')
    $('#map td').removeData('map_vision')
  $('#map_vision').click ->
    if is_vision
      $(this).text('視界表示オフ')
      is_vision = false
    else
      $(this).text('視界表示オン')
      is_vision = true
