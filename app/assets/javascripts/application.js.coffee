# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require jquery_ujs
#= require jquery.ui.all
#= require bootstrap
#= require socket.io
#= require ./plugins/textCounter
#= require ./plugins/textTransformer
#= require ./plugins/textEditor
#= require_tree ./plugins
#= require_self
#= require_tree .
$ ->
  $.fn.popover.defaults = $.extend({} , $.fn.popover.defaults, {
    placement: 'bottom'
    trigger: 'manual'
    html: true
  })
  $('body').delegate 'a[href=#]', 'click', (event) ->
    event.preventDefault()
  $('body').delegate 'a.close.close-popover', 'click', (event) ->
    if this == event.target
      event.stopPropagation()
      $(this).parents("div.popover").prev("[rel=popover]").popover("hide")
  $('[rel*=tooltip]').tooltip()
  $('[rel*=popover]').popover()
