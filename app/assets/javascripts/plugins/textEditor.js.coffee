$ ->
  $.fn.textEditor = (options = {}) ->
    defaults = {
      type: "string"
    }
    
    options = $.extend defaults, options
    
    this.each ->
      $strong = $('<button>').html('太').addClass('btn btn-danger').click (event) =>
        event.preventDefault()
        selText = $(this).selection()
        if selText
          $(this).selection('insert', {text: '<太>', mode: 'before'})
                 .selection('insert', {text: '<細>', mode: 'after'}).trigger('keyup')
        else
          $(this).selection('insert', {text: '<太>', mode: 'before'}).trigger('keyup')
      $italic = $('<button>').html('斜').addClass('btn btn-danger').click (event) =>
        event.preventDefault()
        selText = $(this).selection()
        if selText
          $(this).selection('insert', {text: '<斜>', mode: 'before'})
                 .selection('insert', {text: '<斜>', mode: 'after'}).trigger('keyup')
        else
          $(this).selection('insert', {text: '<斜>', mode: 'before'}).trigger('keyup')
      $under = $('<button>').html('下').addClass('btn btn-danger').click (event) =>
        event.preventDefault()
        selText = $(this).selection()
        if selText
          $(this).selection('insert', {text: '<下>', mode: 'before'})
                 .selection('insert', {text: '<下>', mode: 'after'}).trigger('keyup')
        else
          $(this).selection('insert', {text: '<下>', mode: 'before'}).trigger('keyup')
      $del = $('<button>').html('消').addClass('btn btn-danger').click (event) =>
        event.preventDefault()
        selText = $(this).selection()
        if selText
          $(this).selection('insert', {text: '<消>', mode: 'before'})
                 .selection('insert', {text: '<消>', mode: 'after'}).trigger('keyup')
        else
          $(this).selection('insert', {text: '<消>', mode: 'before'}).trigger('keyup')
      $big = $('<button>').html('大').addClass('btn btn-danger').click (event) =>
        event.preventDefault()
        selText = $(this).selection()
        if selText
          $(this).selection('insert', {text: '<大>', mode: 'before'})
                 .selection('insert', {text: '<中>', mode: 'after'}).trigger('keyup')
        else
          $(this).selection('insert', {text: '<大>', mode: 'before'}).trigger('keyup')
      $small = $('<button>').html('小').addClass('btn btn-danger').click (event) =>
        event.preventDefault()
        selText = $(this).selection()
        if selText
          $(this).selection('insert', {text: '<小>', mode: 'before'})
                 .selection('insert', {text: '<中>', mode: 'after'}).trigger('keyup')
        else
          $(this).selection('insert', {text: '<小>', mode: 'before'}).trigger('keyup')
      $ruby = $('<button>').html('ルビ').addClass('btn btn-danger').click (event) =>
        event.preventDefault()
        selText = $(this).selection()
        if selText
          $(this).selection('insert', {text: '<'+selText+'>^<', mode: 'before'})
                 .selection('replace', {text: ''})
                 .selection('insert', {text: '>', mode: 'after'}).trigger('keyup')
        else
          $(this).selection('insert', {text: '<この文字列にルビを振る>^<', mode: 'before'})
                 .selection('replace', {text: ''})
                 .selection('insert', {text: '>', mode: 'after'}).trigger('keyup')
      $color1 = $('<button>').html('赤').addClass('btn btn-danger').click (event) =>
        event.preventDefault()
        selText = $(this).selection()
        if selText
          $(this).selection('insert', {text: '<赤>', mode: 'before'})
                 .selection('insert', {text: '<黒>', mode: 'after'}).trigger('keyup')
        else
          $(this).selection('insert', {text: '<赤>', mode: 'before'}).trigger('keyup')
      $color2 = $('<button>').html('橙').addClass('btn btn-danger').click (event) =>
        event.preventDefault()
        selText = $(this).selection()
        if selText
          $(this).selection('insert', {text: '<橙>', mode: 'before'})
                 .selection('insert', {text: '<黒>', mode: 'after'}).trigger('keyup')
        else
          $(this).selection('insert', {text: '<橙>', mode: 'before'}).trigger('keyup')
      $color3 = $('<button>').html('黄').addClass('btn btn-danger').click (event) =>
        event.preventDefault()
        selText = $(this).selection()
        if selText
          $(this).selection('insert', {text: '<黄>', mode: 'before'})
                 .selection('insert', {text: '<黒>', mode: 'after'}).trigger('keyup')
        else
          $(this).selection('insert', {text: '<黄>', mode: 'before'}).trigger('keyup')
      $color4 = $('<button>').html('緑').addClass('btn btn-danger').click (event) =>
        event.preventDefault()
        selText = $(this).selection()
        if selText
          $(this).selection('insert', {text: '<緑>', mode: 'before'})
                 .selection('insert', {text: '<黒>', mode: 'after'}).trigger('keyup')
        else
          $(this).selection('insert', {text: '<緑>', mode: 'before'}).trigger('keyup')
      $color5 = $('<button>').html('青').addClass('btn btn-danger').click (event) =>
        event.preventDefault()
        selText = $(this).selection()
        if selText
          $(this).selection('insert', {text: '<青>', mode: 'before'})
                 .selection('insert', {text: '<黒>', mode: 'after'}).trigger('keyup')
        else
          $(this).selection('insert', {text: '<青>', mode: 'before'}).trigger('keyup')
      $color6 = $('<button>').html('藍').addClass('btn btn-danger').click (event) =>
        event.preventDefault()
        selText = $(this).selection()
        if selText
          $(this).selection('insert', {text: '<藍>', mode: 'before'})
                 .selection('insert', {text: '<黒>', mode: 'after'}).trigger('keyup')
        else
          $(this).selection('insert', {text: '<藍>', mode: 'before'}).trigger('keyup')
      $color7 = $('<button>').html('紫').addClass('btn btn-danger').click (event) =>
        event.preventDefault()
        selText = $(this).selection()
        if selText
          $(this).selection('insert', {text: '<紫>', mode: 'before'})
                 .selection('insert', {text: '<黒>', mode: 'after'}).trigger('keyup')
        else
          $(this).selection('insert', {text: '<紫>', mode: 'before'}).trigger('keyup')
      $default = $('<button>').html('元').addClass('btn btn-danger').click (event) =>
        event.preventDefault()
        $(this)
          .selection('insert', {text: '<元>', mode: 'before'}).trigger('keyup')
      $dice = $('<button>').html('サイコロ').addClass('btn btn-danger').click (event) =>
        event.preventDefault()
        $(this)
          .selection('insert', {text: '<2d6>', mode: 'before'}).trigger('keyup')
      $newline = $('<button>').html('改行').addClass('btn btn-danger').click (event) =>
        event.preventDefault()
        $(this)
          .selection('insert', {text: '<改行>', mode: 'before'}).trigger('keyup')
      $colmun_2 = $('<button>').html('2段組').addClass('btn btn-danger').click (event) =>
        event.preventDefault()
        $(this)
          .selection('insert', {text: '<2段組>', mode: 'before'}).trigger('keyup')
      $colmun_3 = $('<button>').html('3段組').addClass('btn btn-danger').click (event) =>
        event.preventDefault()
        $(this)
          .selection('insert', {text: '<3段組>', mode: 'before'}).trigger('keyup')
      $align_left = $('<button>').html('左寄').addClass('btn btn-danger').click (event) =>
        event.preventDefault()
        selText = $(this).selection()
        if selText
          $(this).selection('insert', {text: "\n<左寄>\n", mode: 'before'})
                 .selection('insert', {text: "\n", mode: 'after'}).trigger('keyup')
        else
          $(this).selection('insert', {text: '<左寄>', mode: 'before'}).trigger('keyup')
      $align_right = $('<button>').html('右寄').addClass('btn btn-danger').click (event) =>
        event.preventDefault()
        selText = $(this).selection()
        if selText
          $(this).selection('insert', {text: "\n<右寄>\n", mode: 'before'})
                 .selection('insert', {text: "\n", mode: 'after'}).trigger('keyup')
        else
          $(this).selection('insert', {text: '<右寄>', mode: 'before'}).trigger('keyup')
      $align_center = $('<button>').html('中寄').addClass('btn btn-danger').click (event) =>
        event.preventDefault()
        selText = $(this).selection()
        if selText
          $(this).selection('insert', {text: "\n<中寄>\n", mode: 'before'})
                 .selection('insert', {text: "\n", mode: 'after'}).trigger('keyup')
        else
          $(this).selection('insert', {text: '<中寄>', mode: 'before'}).trigger('keyup')
      $align_justify = $('<button>').html('均等').addClass('btn btn-danger').click (event) =>
        event.preventDefault()
        selText = $(this).selection()
        if selText
          $(this).selection('insert', {text: "\n<均等>\n", mode: 'before'})
                 .selection('insert', {text: "\n", mode: 'after'}).trigger('keyup')
        else
          $(this).selection('insert', {text: '<均等>', mode: 'before'}).trigger('keyup')
      
      $editor = $('<div>').addClass('span9').hide()
        .append($strong).append($italic).append($under).append($del).append($big).append($small).append($ruby)
        .append($color1).append($color2).append($color3).append($color4).append($color5).append($color6).append($color7).append($default)
      switch options.type
        when 'message', 'document'
          $editor.append($dice).before($newline)
      switch options.type
        when 'document'
          $editor.append($colmun_2).append($colmun_3).append($align_left).append($align_right).append($align_center).append($align_justify)
      $preview = $('<div>').addClass('span9 preview').hide()
      $button = $('<button>').html('エディタ').addClass('btn btn-success').click (event) =>
        event.preventDefault()
        $(this).keyup()
        $editor.toggle()
        $preview.toggle()
      $(this).before($editor)
      $(this).after($button).before($preview)
      # 特殊タグパーサ
      $(this).unbind "keyup"
      $(this).keyup (event) ->
        event.preventDefault()
        tree = parser.parse($(this).val(), options.type)
        $preview.html(textTransformer(tree.html))
        $(this).data('textCounter', tree.count.length).trigger("textCounter")
      $(this).keyup()
