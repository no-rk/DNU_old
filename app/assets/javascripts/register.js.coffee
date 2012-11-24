# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  #メニュー書き換え
  $.cleditor.defaultOptions.controls =
    "bold italic underline strikethrough ruby removeformat | " +
    "undo redo | cut copy paste pastetext | source"
  #iframeのBodyStyle
  $.cleditor.defaultOptions.bodyStyle = "cursor:text"

  # 古い動作を保存しておく
  oldAreaCallback = $.cleditor.defaultOptions.updateTextArea
  oldFrameCallback = $.cleditor.defaultOptions.updateFrame
  #テキストエリアを書き換えるとき
  $.cleditor.defaultOptions.updateTextArea = (html) ->
    #古い動作してから
    if oldAreaCallback
      html = oldAreaCallback(html)
    #htmlを特殊タグに書き換える
    return $.cleditor.convertHTMLtoSPode html
  #iframeを書き換えるとき
  $.cleditor.defaultOptions.updateFrame = (code) ->
    #古い動作してから
    if oldFrameCallback
      code = oldFrameCallback(code)
    #特殊タグをhtmlに書き換える
    return $.cleditor.convertSPodeToHTML code
  #htmlを特殊タグに置換
  $.cleditor.convertHTMLtoSPode = (html) ->
    $.each [
      [/[\r|\n]/g, ""]
      [/<br.*?>/gi, "\n"]
      [/<b>(.*?)<\/b>/gi, "[b]$1[/b]"]
      [/<strong>(.*?)<\/strong>/gi, "[b]$1[/b]"]
      [/<i>(.*?)<\/i>/gi, "[i]$1[/i]"]
      [/<em>(.*?)<\/em>/gi, "[i]$1[/i]"]
      [/<u>(.*?)<\/u>/gi, "[u]$1[/u]"]
      [/<ins>(.*?)<\/ins>/gi, "[u]$1[/u]"]
      [/<strike>(.*?)<\/strike>/gi, "[s]$1[/s]"]
      [/<del>(.*?)<\/del>/gi, "[s]$1[/s]"]
      [/<a.*?href="(.*?)".*?>(.*?)<\/a>/gi, "[url=$1]$2[/url]"]
      [/<img.*?src="(.*?)".*?>/gi, "[img]$1[/img]"]
      [/<ul>/gi, "[list]"]
      [/<\/ul>/gi, "[/list]"]
      [/<ol>/gi, "[list=1]"]
      [/<\/ol>/gi, "[/list]"]
      [/<li>/gi, "[*]"]
      [/<\/li>/gi, "[/*]"]
      [/<.*?>(.*?)<\/.*?>/g, "$1"]
    ], (index, item) ->
      html = html.replace(item[0], item[1])
    return html
  #特殊タグをhtmlに置換
  $.cleditor.convertSPodeToHTML = (code) ->
    $.each [
      [/\r/g, ""]
      [/\n/g, "<br />"]
      [/\[b\](.*?)\[\/b\]/gi, "<b>$1</b>"]
      [/\[i\](.*?)\[\/i\]/gi, "<i>$1</i>"]
      [/\[u\](.*?)\[\/u\]/gi, "<u>$1</u>"]
      [/\[s\](.*?)\[\/s\]/gi, "<strike>$1</strike>"]
      [/\[url=(.*?)\](.*?)\[\/url\]/gi, "<a href=\"$1\">$2</a>"]
      [/\[img\](.*?)\[\/img\]/gi, "<img src=\"$1\">"]
      [/\[list\](.*?)\[\/list\]/gi, "<ul>$1</ul>"]
      [/\[list=1\](.*?)\[\/list\]/gi, "<ol>$1</ol>"]
      [/\[list\]/gi, "<ul>"]
      [/\[list=1\]/gi, "<ol>"]
      [/\[\*\](.*?)\[\/\*\]/g, "<li>$1</li>"]
      [/\[\*\]/g, "<li>"]
    ], (index, item) ->
      code = code.replace(item[0], item[1])
    return code

  #ボタン動作定義
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
  #ボタン内容定義
  $.cleditor.buttons.ruby = {
    stripIndex: 5
    name: "ruby"
    title: "ルビ振る"
    command: "inserthtml"
    popupName: "ruby"
    popupClass: "cleditorPrompt"
    popupContent: '表示はブラウザに依存するので使うときは注意。<br><input type="text"><input type="button" value="Submit">'
    buttonClick: rubyButtonClick
  }

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