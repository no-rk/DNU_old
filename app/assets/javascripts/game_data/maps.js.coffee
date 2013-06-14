# マップ
$ ->
  is_draw   = false
  is_vision = false
  start_cell = undefined
  $.fn.changeTip = (is_recursion = false) ->
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
      $(this).attr("class",map4_class).addClass('map4_tip_' + tip_number)
      if is_recursion
        $map1.changeTip()
        $map2.changeTip()
        $map3.changeTip()
  $.fn.simpleTip = () ->
    $map0 = $(this)
    if $map0.is('div')
      map4_class = $map0.data('map4_class')
      $(this).attr("class",map4_class).addClass('map4_tip_0')
  $.fn.drawMap = (is_simple = false, is_edit = false, landform = $('#map_tool tr.selected').attr('id'), map_collision = $('#map_tool tr.selected').find(':checkbox').is(':checked'), map_opacity = $('#map_tool tr.selected').find('input[type=number]').val()) ->
    $(this).attr("class",landform)
    unless is_edit
      x = $(this).data('map_x')
      y = $(this).data('map_y')
      $('#landform_'  + x +  '_' + y).val(landform)
      $('#collision_' + x +  '_' + y).val(if map_collision then 1 else 0)
      $('#opacity_'   + x +  '_' + y).val(map_opacity)
    $(this).find('div.map_collision').removeClass('true')
    if map_collision
      $(this).find('div.map_collision').addClass('true')
    if map_opacity > 0
      $(this).find('div.map_opacity').html('<p>' + map_opacity + '</p>')
    else
      $(this).find('div.map_opacity').empty()
    $(this).data('map_collision', map_collision)
    $(this).data('map_opacity', map_opacity)
    if is_simple
      $(this).find('div.map_ur').simpleTip()
      $(this).find('div.map_lr').simpleTip()
      $(this).find('div.map_ll').simpleTip()
      $(this).find('div.map_ul').simpleTip()
    else if is_edit
      $(this).find('div.map_ur').changeTip()
      $(this).find('div.map_lr').changeTip()
      $(this).find('div.map_ll').changeTip()
      $(this).find('div.map_ul').changeTip()
    else
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
  $.fn.setMap = ->
    $map = $(this)
    $map.empty()
    $map.addClass($('#map_base').val())
    # テーブル生成
    map_size = $('#map_size').val()-0
    for i in [1..map_size]
      $tr = $('<tr>')
      # 左のラベル
      $tr.append($('<th>').html('<div><p>' + String.fromCharCode(64+i) + '</p></div>'))
      for j in [1..map_size]
        $td = $('<td>')
        $tr.append($td)
      # 右のラベル
      $tr.append($('<th>').html('<div><p>' + String.fromCharCode(64+i) + '</p></div>'))
      $map.append($tr)
    # 上下のラベル
    $tr_t = $('<tr>')
    $tr_b = $('<tr>')
    for i in [0..(map_size+1)]
      $th_t = $('<th>')
      $th_b = $('<th>')
      if i==0 or i==map_size+1
        $th_t.html('<div><p>　</p></div>')
        $th_b.html('<div><p>　</p></div>')
      else
        $th_t.html('<div><p>' + i + '</p></div>')
        $th_b.html('<div><p>' + i + '</p></div>')
      $tr_t.append($th_t)
      $tr_b.append($th_b)
    $map.prepend($tr_t).append($tr_b)
    # 初期情報付与
    $map.find('tr').each (i, tr) ->
      map_x = i
      tip_x = i-1
      $(tr).children('td').each (j, td) ->
        map_y = j+1
        tip_y = j
        $(td).addClass($('#landform_'  + map_x +  '_' + map_y).val())
        $(td).attr('id', 'map_' + map_x + '_' + map_y)
        $(td).data('map_x', map_x)
        $(td).data('map_y', map_y)
        $base      = $('<div>').addClass('map_base')
        $inner     = $('<div>').addClass('map_inner')
        $collision = $('<div>').addClass('map_collision')
        $opacity = $('<div>').addClass('map_opacity')
        $ur = $('<div>').attr('id', 'map4_' +  2*tip_x    + '_' + (2*tip_y+1)).addClass('map_ur map4_tip_0').data('map4_class', 'map_ur').data('map4_x',  2*tip_x   ).data('map4_y', (2*tip_y+1))
        $lr = $('<div>').attr('id', 'map4_' + (2*tip_x+1) + '_' + (2*tip_y+1)).addClass('map_lr map4_tip_0').data('map4_class', 'map_lr').data('map4_x', (2*tip_x+1)).data('map4_y', (2*tip_y+1))
        $ll = $('<div>').attr('id', 'map4_' + (2*tip_x+1) + '_' +  2*tip_y   ).addClass('map_ll map4_tip_0').data('map4_class', 'map_ll').data('map4_x', (2*tip_x+1)).data('map4_y',  2*tip_y   )
        $ul = $('<div>').attr('id', 'map4_' +  2*tip_x    + '_' +  2*tip_y   ).addClass('map_ul map4_tip_0').data('map4_class', 'map_ul').data('map4_x',  2*tip_x   ).data('map4_y',  2*tip_y   )
        $(td).append($base.append($ur).append($lr).append($ll).append($ul).append($inner).append($collision).append($opacity))
    # 動作定義
    $map.mousedown ->
      is_draw = true
    $map.mouseup ->
      is_draw = false
    $map.find('td').mousedown ->
      switch $('#map_draw').val()
        when 'pen'
          $(this).drawMap()
        when 'rectangle'
          start_cell = $(this)
    $map.find('td').mouseup ->
      switch $('#map_draw').val()
        when 'rectangle'
          if start_cell?
            $td = $(this)
            bb = []
            for x in [start_cell.data('map_x')..$td.data('map_x')]
              for y in [start_cell.data('map_y')..$td.data('map_y')]
                if x==start_cell.data('map_x') or x==$td.data('map_x') or y==start_cell.data('map_y') or y==$td.data('map_y')
                  bb.push($('td#map_' + x + '_' +  y))
                else
                  $('td#map_' + x + '_' +  y).drawMap(true)
            # 最後に枠を描く
            for $b in bb
              $b.drawMap()
      start_cell = undefined
    $map.find('td').hover ->
      if is_draw
        switch $('#map_draw').val()
          when 'pen'
            $(this).drawMap()
          when 'rectangle'
            if start_cell?
              for x in [start_cell.data('map_x')..$(this).data('map_x')]
                for y in [start_cell.data('map_y')..$(this).data('map_y')]
                  $('td#map_' + x + '_' +  y).children('div.map_base').addClass('enlighten')
      if is_vision and !start_cell?
        enlighten = ($center, vision, map_opacity = $center.data('map_opacity') ? 0) ->
          $center.data('map_vision', vision)
          $center.children('div.map_base').addClass('enlighten')
          next_vision = vision - 1 - map_opacity
          if next_vision >= 0
            $.each $center.aroundMap(next_vision), (i, $place) ->
              enlighten($place, next_vision)
        enlighten($(this), $('#vision_size').val(), 0)
    , ->
      $map.find('td div.map_base').removeClass('enlighten')
      $map.find('td').removeData('map_vision')
  $('#map').setMap()
  # マップロード
  unless $('#map_new').val()
    para = (x, y) ->
      setTimeout ->
        landform  = $('#landform_'  + x +  '_' + y).val()
        collision = $('#collision_' + x +  '_' + y).val()-0 == 1
        opacity   = $('#opacity_'   + x +  '_' + y).val()
        $('td#map_' + x + '_' + y).drawMap(false, true, landform, collision, opacity)
    map_size = $('#map_size').val()-0
    for x in [1..map_size]
      for y in [1..map_size]
        para(x, y)
  $('#map_base').change ->
    $('#map').attr("class",$(this).val())
  $('#map_tool tr').click ->
    $('#map_tool tr').removeClass('selected')
    $(this).addClass('selected')
  $('#map_vision').click ->
    if is_vision
      $(this).text('視界表示オフ')
      is_vision = false
    else
      $(this).text('視界表示オン')
      is_vision = true
