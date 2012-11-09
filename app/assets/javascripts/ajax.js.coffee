# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  #リンクヘルプAjax
  $(document).delegate 'a[data-remote]', 'ajax:success', (event, data, status, xhr) ->
    event.stopPropagation()
    $(this).attr({
      "data-original-title": data.model + "::" + data.name
      "data-content": data.caption
    })
    $(this).popover('toggle')
    $(this).unbind("click").bind "click", =>
      $(this).popover('toggle')
      false
  #セレクトヘルプAjax
  $(document).delegate 'select[data-remote]', 'ajax:before', (event) ->
    event.stopPropagation()
    $(this).data("params","id=" + $(this).val())
  $(document).delegate 'select[data-remote]', 'ajax:success', (event, data, status, xhr) ->
    event.stopPropagation()
    $(this).removeAttr("data-params")
    next = $(this).next('a[data-remote]')
    next.data("params","id=" + $(this).val())
    next.attr({
      "data-params": "id=" + $(this).val()
      "data-original-title": data.model + "::" + data.name
      "data-content": data.caption
    })
    next.popover("show") if next.data("popover").$tip? && next.data("popover").$tip.hasClass("in")
  #ボタン確認Ajax
  $(document).delegate 'button[data-remote]', 'click.rails', (event) ->
    event.stopPropagation()
    form = $(this).parents('form:first')
    form.data("remote",true)
    form.data("type","html")
    form.submit()
    form.removeData("remote")
    false
  $(document).delegate 'form', 'ajax:success', (event, data, status, xhr) ->
    event.stopPropagation()
    $(this).after('<div class="alert"></div>')
    $(this).next('div').html(data)
    $(this).next('div').prepend('<button type="button" class="close" data-dismiss="alert">（・×・）</button><br />')