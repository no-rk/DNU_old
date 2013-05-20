$ ->
  $.fn.textCounter = (options = {}) ->
    defaults = {
      css: 'badge'
      counterElement: 'span'
      cssWarning: 'badge-warning'
      cssExceeded: 'badge-important'
      counterText: '残り'
    }
    
    options = $.extend defaults, options
    
    this.each ->
      $counter = $("<#{options.counterElement}>")
      $counter.addClass(options.css)
      $(this).closest('.controls').prev().append($counter)
      maxChars     = $(this).data("maxlength")
      warningChars = Math.floor(maxChars/10)
      counterElement = $(this).closest('.controls').prev().find(options.counterElement)
      
      calculate = =>
        count = $(this).data("textCounter") ? $(this).val().length
        available = maxChars - count
        
        if available <= warningChars and available > 0
          counterElement.addClass(options.cssWarning)
        else
          counterElement.removeClass(options.cssWarning)
        if available <= 0
          counterElement.addClass(options.cssExceeded)
        else
          counterElement.removeClass(options.cssExceeded)
        counterElement.html(options.counterText + available + "文字")
      
      calculate()
      $(this).bind "textCounter", ->
        calculate()
      $(this).keyup ->
        $(this).trigger("textCounter")
