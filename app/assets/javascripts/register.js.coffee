# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $(':text[maxlength],textarea[maxlength]').charCount()
  #ボタン確認
  $('body.register').delegate 'form.select_submit select', 'change.rails', (event) ->
    #親要素のフォームを取得
    form = $(this).parents('form:first')
    form.submit()
    console.log('form.select_submit select change.rails')