$ ->
  $.fn.textEditorButton = ($button, caption, start_tag, end_tag, separator) ->
    $button
      .data("title", caption).tooltip()
      .click (event) =>
        event.preventDefault()
        selText = $(this).selection()
        if separator
          $(this).selection('insert', {text: "#{start_tag}#{selText || caption}#{separator}", mode: 'before'})
                 .selection('replace', {text: ''})
                 .selection('insert', {text: end_tag, mode: 'after'})
        else
          $(this).selection('insert', {text: "<#{start_tag}>", mode: 'before'})
          if selText and end_tag
            $(this).selection('insert', {text: "<#{end_tag}>", mode: 'after'})
        $(this).keyup()
  
  $.fn.textEditor = (options = {}) ->
    defaults = {
      type: "string"
    }
    
    options = $.extend defaults, options
    
    this.each ->
      $strong        = $(this).textEditorButton($('<button>').html("太").addClass('btn btn-danger'), "太字にする。", "太", "細")
      $italic        = $(this).textEditorButton($('<button>').html("斜").addClass('btn btn-danger'), "斜体にする。", "斜", "斜")
      $under         = $(this).textEditorButton($('<button>').html("下").addClass('btn btn-danger'), "下線をひく。", "下", "下")
      $del           = $(this).textEditorButton($('<button>').html("消").addClass('btn btn-danger'), "打消しする。", "消", "消")
      $big           = $(this).textEditorButton($('<button>').html("大").addClass('btn btn-danger'), "文字大きく。", "大", "中")
      $small         = $(this).textEditorButton($('<button>').html("小").addClass('btn btn-danger'), "文字小さく。", "小", "中")
      $color1        = $(this).textEditorButton($('<button>').html("赤").addClass('btn btn-danger'), "文字赤色に。", "赤", "#")
      $color2        = $(this).textEditorButton($('<button>').html("橙").addClass('btn btn-danger'), "文字橙色に。", "橙", "#")
      $color3        = $(this).textEditorButton($('<button>').html("黄").addClass('btn btn-danger'), "文字黄色に。", "黄", "#")
      $color4        = $(this).textEditorButton($('<button>').html("緑").addClass('btn btn-danger'), "文字緑色に。", "緑", "#")
      $color5        = $(this).textEditorButton($('<button>').html("青").addClass('btn btn-danger'), "文字青色に。", "青", "#")
      $color6        = $(this).textEditorButton($('<button>').html("藍").addClass('btn btn-danger'), "文字藍色に。", "藍", "#")
      $color7        = $(this).textEditorButton($('<button>').html("紫").addClass('btn btn-danger'), "文字紫色に。", "紫", "#")
      $default       = $(this).textEditorButton($('<button>').html("元").addClass('btn btn-danger'), "タグ効果を終了させ元の状態に戻す。", "元")
      $ruby          = $(this).textEditorButton($('<button>').html("ルビ").addClass('btn btn-danger'), "ルビを振る。", "<", ">", ">^<")
      $r_serif       = $(this).textEditorButton($('<button>').html("乱台詞").addClass('btn btn-danger'), "ランダム表示。", "|", "|", "|")
      $s_serif       = $(this).textEditorButton($('<button>').html("順台詞").addClass('btn btn-danger'), "順番に表示。", "+", "+", "+")
      $random        = $(this).textEditorButton($('<button>').html("乱").addClass('btn btn-danger'), "ランダム表示。", "<", ">", "|")
      $sequence      = $(this).textEditorButton($('<button>').html("順").addClass('btn btn-danger'), "順番に表示。", "<", ">", "+")
      $self_name     = $(this).textEditorButton($('<button>').html("自").addClass('btn btn-danger'), "自分の愛称。", "自分")
      $target_name   = $(this).textEditorButton($('<button>').html("対").addClass('btn btn-danger'), "対象の愛称。", "対象")
      $dice          = $(this).textEditorButton($('<button>').html("賽").addClass('btn btn-danger'), "サイコロを何個か振った合計値。", "2d6")
      $newline       = $(this).textEditorButton($('<button>').html("改").addClass('btn btn-danger'), "改行する。", "改行")
      $colmun_2      = $(this).textEditorButton($('<button>').html("二段").addClass('btn btn-danger'), "2段組にする。", "2段組")
      $colmun_3      = $(this).textEditorButton($('<button>').html("三段").addClass('btn btn-danger'), "3段組にする。", "3段組")
      $align_left    = $(this).textEditorButton($('<button>').html("左寄").addClass('btn btn-danger'), "左寄せにする。", "左寄")
      $align_right   = $(this).textEditorButton($('<button>').html("右寄").addClass('btn btn-danger'), "右寄せにする。", "右寄")
      $align_center  = $(this).textEditorButton($('<button>').html("中寄").addClass('btn btn-danger'), "中央寄せにする。", "中寄")
      $align_justify = $(this).textEditorButton($('<button>').html("両寄").addClass('btn btn-danger'), "均等に配置する。", "均等")
      $list          = $(this).textEditorButton($('<button>').html("並").addClass('btn btn-danger'), "リスト化する。", "並")
      
      $dropdown = $("<div>").addClass("dropdown-menu").css({"max-width": "180px"})
      for k,v of registerIcons
        $dropdown.append($(this).textEditorButton($("<img>").attr("src", v).css({"cursor": "pointer", "float": "left", "width": "30px", "height": "30px"}), "アイコン#{k}", k))
      $icons = $("<div>").addClass("btn-group")
        .append($("<a>").addClass("btn btn-danger btn-dropdown-toggle").html("アイコン").attr("href", "#").attr("data-toggle", "dropdown").append($("<span>").addClass("caret")))
        .append($dropdown)
      
      span = $(this).attr("class").match(/(?:^| )(span\d+)(?:$| )/)
      span = if span then "#{span[1]} " else ""
      $editor = $('<div>').addClass("#{span}editor").hide()
      switch options.type
        when 'string', 'message', 'document'
          $editor
            .append($strong).append($italic).append($under).append($del).append($big).append($small)
            .append($color1).append($color2).append($color3).append($color4).append($color5).append($color6).append($color7).append($default).append($ruby)
      switch options.type
        when 'message', 'document'
          $editor
            .append($icons).append($r_serif).append($s_serif).append($sequence).append($random).append($self_name).append($target_name).append($dice).append($newline)
      switch options.type
        when 'document'
          $editor
            .append($colmun_2).append($colmun_3).append($align_left).append($align_right).append($align_center).append($align_justify).append($list)
      $preview = $('<div>').addClass("#{span}preview").hide()
      $button = $('<button>').html('エディタ').addClass('btn btn-small btn-inverse').css("vertical-align", "top").click (event) =>
        event.preventDefault()
        $(this).keyup()
        $editor.toggle()
        $preview.toggle()
      $(this).before($editor).after($preview).after($button)
      # 特殊タグパーサ
      $(this).unbind "keyup"
      $(this).keyup (event) ->
        event.preventDefault()
        tree = parser.parse($(this).val(), options.type)
        $preview.html(textTransformer(tree.html, registerIcons))
        $(this).data('textCounter', tree.count.length).trigger("textCounter")
      $(this).keyup()
