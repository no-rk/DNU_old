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
#= require bootstrap
#= require ./plugins/textCounter
#= require ./plugins/textTransformer
#= require ./plugins/textEditor
#= require_tree ./plugins
#= require_self
#= require_tree .
$ ->
  $.fn.popover.defaults = $.extend({} , $.fn.tooltip.defaults, {
    placement: 'right'
    trigger: 'manual'
    content: ''
    template: '<div class="popover"><div class="arrow"></div><div class="popover-inner"><a class="close icon-remove-sign" href="#"></a><h3 class="popover-title"></h3><div class="popover-content"></div></div></div>'
    html: true
  })
  $('body').delegate 'a[href=#]', 'click', (event) ->
    event.preventDefault()
  $('body').delegate 'a.close', 'click', (event) ->
    $('a[rel*=popover]').popover('hide')
  $('a[rel*=tooltip]').tooltip()
  $('a[rel*=popover]').popover()
