# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  # カウンタ
  $(':text[data-maxlength]').textCounter()
  $('textarea[data-maxlength]').textCounter()
  # エディタ
  $('[type!=hidden].string-editor').textEditor({type: "string"})
  $('[type!=hidden].message-editor').textEditor({type: "message"})
  $('[type!=hidden].document-editor').textEditor({type: "document"})
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
