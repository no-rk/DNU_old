# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  #メニュー書き換え
  $.cleditor.defaultOptions.controls =
    "bold italic underline strikethrough size color removeformat | ruby icon | " +
    "undo redo | cut copy paste pastetext | source"
  $.cleditor.buttons.bold.title          = "太字"
  $.cleditor.buttons.italic.title        = "斜体"
  $.cleditor.buttons.underline.title     = "下線"
  $.cleditor.buttons.strikethrough.title = "打消"
  $.cleditor.buttons.removeformat.title  = "タグ消去"
  $.cleditor.buttons.size.title          = "フォントサイズ"
  $.cleditor.buttons.color.title         = "フォントカラー"
  $.cleditor.buttons.undo.title          = "元に戻す"
  $.cleditor.buttons.redo.title          = "やり直し"
  #iframeのBodyStyle
  $.cleditor.defaultOptions.docCSSFile = $("link[type='text/css']").attr("href")
  $.cleditor.defaultOptions.bodyStyle = "cursor:text;background-color:#FFF;"

  #htmlを特殊タグに書き換える
  $.cleditor.defaultOptions.updateTextArea = (html) ->
    console.log("html_to")
    console.log(html)
    $.ajaxSetup({async: false})
    $.post DNU.AJAX_HTML_TO_URL,{
      "html": html
    }, (data) ->
      html = data.code
    ,"json"
    $.ajaxSetup({async: true})
    console.log(html)
    return html

  #特殊タグをhtmlに書き換える
  $.cleditor.defaultOptions.updateFrame = (code) ->
    console.log("to_html")
    console.log(code)
    $.ajaxSetup({async: false})
    $.post DNU.AJAX_TO_HTML_URL,{
      "code": code
    }, (data) ->
      code = data.html
    ,"json"
    $.ajaxSetup({async: true})
    console.log(code)
    return code

  #ルビボタン動作定義
  rubyButtonClick = (e, data) ->
    editor = data.editor
    buttonDiv = e.target
    if editor.selectedText(editor) == ""
      editor.showMessage("ルビを振りたい文字列を選択してから押してください。", buttonDiv)
      return false
    $(data.popup).children(":button").unbind("click").bind "click", (e) ->
      editor = data.editor
      $text = $(data.popup).find(":text")
      ruby = $text[0].value
      if ruby
        html = '<ruby><rb>' + editor.selectedText(editor) + '</rb><rt>' + ruby + '</rt></ruby>'
      if (html)
        editor.execCommand(data.command, html, null, data.button)
      $text.val("")
      editor.hidePopups()
      editor.focus()
  #ルビボタン内容定義
  $.cleditor.buttons.ruby = {
    stripIndex: 5
    name: "ruby"
    title: "ルビ"
    command: "inserthtml"
    popupName: "ruby"
    popupClass: "cleditorPrompt"
    popupContent: '表示はブラウザに依存するので使うときは注意。<br><input type="text"><input type="button" value="Submit">'
    buttonClick: rubyButtonClick
  }

  #アイコンボタン内容定義
  $content = $('<div>')
  if DNU.ICONS
    count = 0
    $.each DNU.ICONS, (idx, icon) ->
      $('<div>').data("icon-no": idx).css({
        width: DNU.ICON_WIDTH
        height: DNU.ICON_HEIGHT
        backgroundImage: 'url(' + icon + ')'
        cursor: "pointer"
      }).css("float", "left").appendTo($content)
      console.log(idx+":"+icon)
      count++
    DNU.ICON_COUNT = count if DNU.ICON_COUNT > count
  $.cleditor.buttons.icon = {
    stripIndex: 23
    name: "icon"
    title: "アイコン"
    command: "inserthtml"
    popupName: "icon"
    popupContent: $content.css("width":DNU.ICON_WIDTH*DNU.ICON_COUNT)
    popupClick: (e,data) ->
      icon_no = $(e.target).data("icon-no")
      data.value = '<img no="' + icon_no + '" src="' + DNU.ICONS[icon_no] + '" class="icon">'
  }
  #初期化
  $(':text[maxlength]').charCount()
  $('textarea[maxlength]').cleditor()
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