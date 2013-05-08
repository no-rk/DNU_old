# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  # transform
  transform = (tree) ->
    map_inners = (inners) ->
      inners.map (inner,index) ->
        transform(inner)
    switch tree.tag
      when undefined
        tree
      when 'message', 'element'
        map_inners(tree.inner).join('')
      when 'column_2', 'column_3', 'align_left', 'align_right', 'align_center', 'align_justify'
        "<div class='#{tree.tag}'>#{map_inners(tree.inner).join('')}</div>"
      when 'icon'
        "<div class='serif #{tree.data.position}'><div class='icon'><div class='icon_test'>#{tree.data.number}</div></div><div class='balloon #{tree.data.balloon}'>#{map_inners(tree.inner).join('')}</div></div>"
      when 'color'
        "<font color='#{tree.data.color}'>#{map_inners(tree.inner).join('')}</font>"
      when 'random'
        "【#{map_inners(tree.inner).join('】または【')}】"
      when 'sequence'
        "【#{map_inners(tree.inner).join('】⇒【')}】"
      when 'dice'
        "【#{tree.data.number}面ダイスを#{tree.data.count}個振った合計値】"
      when 'br'
        "<br>"
      else
        "<#{tree.tag}>#{map_inners(tree.inner).join('')}</#{tree.tag}>"
  $('body').delegate 'textarea[data-maxlength].document', 'keyup', (event) ->
    val = $(this).val()
    tree = parser.parse(val,"document")
    console.log(tree.html)
    console.log(tree.count)
    $(this).next('.preview').html(transform(tree.html))
  $('body').delegate 'textarea[data-maxlength].message', 'keyup', (event) ->
    val = $(this).val()
    tree = parser.parse(val,"message")
    console.log(tree.html)
    console.log(tree.count)
    $(this).next('.preview').html(transform(tree.html))
  #初期化
  $(':text[data-maxlength]').charCount()
  $('textarea[data-maxlength].message').each (i) ->
    $strong = $('<button>').html('太').addClass('btn btn-danger').click (event) ->
      event.preventDefault()
      selText = $(this).closest('.editor' + (i+1)).next().selection()
      if selText
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<太>', mode: 'before'})
          .selection('insert', {text: '<細>', mode: 'after'}).trigger('keyup')
      else
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<太>', mode: 'before'}).trigger('keyup')
    $italic = $('<button>').html('斜').addClass('btn btn-danger').click (event) ->
      event.preventDefault()
      selText = $(this).closest('.editor' + (i+1)).next().selection()
      if selText
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<斜>', mode: 'before'})
          .selection('insert', {text: '<斜>', mode: 'after'}).trigger('keyup')
      else
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<斜>', mode: 'before'}).trigger('keyup')
    $under = $('<button>').html('下').addClass('btn btn-danger').click (event) ->
      event.preventDefault()
      selText = $(this).closest('.editor' + (i+1)).next().selection()
      if selText
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<下>', mode: 'before'})
          .selection('insert', {text: '<下>', mode: 'after'}).trigger('keyup')
      else
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<下>', mode: 'before'}).trigger('keyup')
    $del = $('<button>').html('消').addClass('btn btn-danger').click (event) ->
      event.preventDefault()
      selText = $(this).closest('.editor' + (i+1)).next().selection()
      if selText
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<消>', mode: 'before'})
          .selection('insert', {text: '<消>', mode: 'after'}).trigger('keyup')
      else
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<消>', mode: 'before'}).trigger('keyup')
    $big = $('<button>').html('大').addClass('btn btn-danger').click (event) ->
      event.preventDefault()
      selText = $(this).closest('.editor' + (i+1)).next().selection()
      if selText
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<大>', mode: 'before'})
          .selection('insert', {text: '<中>', mode: 'after'}).trigger('keyup')
      else
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<大>', mode: 'before'}).trigger('keyup')
    $small = $('<button>').html('小').addClass('btn btn-danger').click (event) ->
      event.preventDefault()
      selText = $(this).closest('.editor' + (i+1)).next().selection()
      if selText
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<小>', mode: 'before'})
          .selection('insert', {text: '<中>', mode: 'after'}).trigger('keyup')
      else
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<小>', mode: 'before'}).trigger('keyup')
    $ruby = $('<button>').html('ルビ').addClass('btn btn-danger').click (event) ->
      event.preventDefault()
      selText = $(this).closest('.editor' + (i+1)).next().selection()
      if selText
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<'+selText+'>^<', mode: 'before'})
          .selection('replace', {text: ''})
          .selection('insert', {text: '>', mode: 'after'}).trigger('keyup')
      else
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<この文字列にルビを振る>^<', mode: 'before'})
          .selection('replace', {text: ''})
          .selection('insert', {text: '>', mode: 'after'}).trigger('keyup')
    $color1 = $('<button>').html('赤').addClass('btn btn-danger').click (event) ->
      event.preventDefault()
      selText = $(this).closest('.editor' + (i+1)).next().selection()
      if selText
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<赤>', mode: 'before'})
          .selection('insert', {text: '<黒>', mode: 'after'}).trigger('keyup')
      else
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<赤>', mode: 'before'}).trigger('keyup')
    $color2 = $('<button>').html('橙').addClass('btn btn-danger').click (event) ->
      event.preventDefault()
      selText = $(this).closest('.editor' + (i+1)).next().selection()
      if selText
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<橙>', mode: 'before'})
          .selection('insert', {text: '<黒>', mode: 'after'}).trigger('keyup')
      else
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<橙>', mode: 'before'}).trigger('keyup')
    $color3 = $('<button>').html('黄').addClass('btn btn-danger').click (event) ->
      event.preventDefault()
      selText = $(this).closest('.editor' + (i+1)).next().selection()
      if selText
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<黄>', mode: 'before'})
          .selection('insert', {text: '<黒>', mode: 'after'}).trigger('keyup')
      else
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<黄>', mode: 'before'}).trigger('keyup')
    $color4 = $('<button>').html('緑').addClass('btn btn-danger').click (event) ->
      event.preventDefault()
      selText = $(this).closest('.editor' + (i+1)).next().selection()
      if selText
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<緑>', mode: 'before'})
          .selection('insert', {text: '<黒>', mode: 'after'}).trigger('keyup')
      else
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<緑>', mode: 'before'}).trigger('keyup')
    $color5 = $('<button>').html('青').addClass('btn btn-danger').click (event) ->
      event.preventDefault()
      selText = $(this).closest('.editor' + (i+1)).next().selection()
      if selText
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<青>', mode: 'before'})
          .selection('insert', {text: '<黒>', mode: 'after'}).trigger('keyup')
      else
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<青>', mode: 'before'}).trigger('keyup')
    $color6 = $('<button>').html('藍').addClass('btn btn-danger').click (event) ->
      event.preventDefault()
      selText = $(this).closest('.editor' + (i+1)).next().selection()
      if selText
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<藍>', mode: 'before'})
          .selection('insert', {text: '<黒>', mode: 'after'}).trigger('keyup')
      else
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<藍>', mode: 'before'}).trigger('keyup')
    $color7 = $('<button>').html('紫').addClass('btn btn-danger').click (event) ->
      event.preventDefault()
      selText = $(this).closest('.editor' + (i+1)).next().selection()
      if selText
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<紫>', mode: 'before'})
          .selection('insert', {text: '<黒>', mode: 'after'}).trigger('keyup')
      else
        $(this).closest('.editor' + (i+1)).next()
          .selection('insert', {text: '<紫>', mode: 'before'}).trigger('keyup')
    $default = $('<button>').html('元').addClass('btn btn-danger').click (event) ->
      event.preventDefault()
      $(this).closest('.editor' + (i+1)).next()
        .selection('insert', {text: '<元>', mode: 'before'}).trigger('keyup')
    $editor = $('<div>').addClass('span9 editor' + (i+1))
      .append($strong).append($italic).append($under).append($del).append($big).append($small).append($ruby)
      .append($color1).append($color2).append($color3).append($color4).append($color5).append($color6).append($color7).append($default).hide()
    $button = $('<button>').html('エディタ').addClass('btn btn-success').click (event) ->
      event.preventDefault()
      $('.editor' + (i+1)).toggle()
    $preview = $('<div>').addClass('span9 preview editor' + (i+1)).hide()
    $(this).before($editor)
    $(this).after($button).after($preview)
  $('textarea[data-maxlength]').charCount({text: true})
  $('textarea[data-maxlength].document').each (i) ->
    $button = $('<button>').html('エディタ').addClass('btn btn-success').click (event) ->
      event.preventDefault()
      $('.editor' + (i+1)).toggle()
    $preview = $('<div>').addClass('span9 preview editor' + (i+1)).hide()
    $(this).after($button).after($preview)
  #セレクトでサブミット
  $('body.register').delegate 'form.select_submit select', 'change.rails', (event) ->
    #親要素のフォームを取得
    form = $(this).parents('form:first')
    form.submit()
    console.log('form.select_submit select change.rails')
  #value合計
  $('div[data-check-total]').each ->
    $(this).prev('label').append('　<span class="badge"></span>')
    maxValue = $(this).data('check-total')
    calculate = (obj) ->
      count = 0
      counterText = '残り'
      $(obj).find('select').each ->
        count += $(this).val()-0
      available = maxValue - count
      if available == 0
        $(obj).prev().children().addClass('badge-important')
      else
        $(obj).prev().children().removeClass('badge-important')
      if available < 0
        $(obj).prev().children().addClass('badge-warning')
        counterText = '超過'
        available *= -1
      else
        $(obj).prev().children().removeClass('badge-warning')
      $(obj).prev().children().html(counterText + available + 'ポイント')
    calculate(this)
    $(this).change ->
      calculate(this)