# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $(document).delegate $.rails.linkClickSelector, 'ajax:success', (e, data) ->
    $(this).attr({
      "data-original-title": data.model + "::" + data.name
      "data-content": data.caption
    })
    $(this).popover('toggle')
    $(this).unbind("click").bind "click", =>
      $(this).popover('toggle')
      false

  $(document).delegate $.rails.inputChangeSelector, 'ajax:before', (e, data) ->
    $(this).data("params","id=" + $(this).val())
  $(document).delegate $.rails.inputChangeSelector, 'ajax:success', (e, data) ->
    $(this).removeAttr("data-params")
    next = $(this).next($.rails.linkClickSelector)
    next.data("params","id=" + $(this).val())
    next.attr({
      "data-params": "id=" + $(this).val()
      "data-original-title": data.model + "::" + data.name
      "data-content": data.caption
    })
    next.popover("show") if next.data("popover").$tip? && next.data("popover").$tip.hasClass("in")