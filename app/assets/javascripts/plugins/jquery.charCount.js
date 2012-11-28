/*
 * 	Character Count Plugin - jQuery plugin
 * 	Dynamic character count for text areas and input fields
 *	written by Alen Grakalic	
 *	http://cssglobe.com/post/7161/jquery-plugin-simplest-twitterlike-dynamic-character-count-for-textareas
 *
 *	Copyright (c) 2009 Alen Grakalic (http://cssglobe.com)
 *	Dual licensed under the MIT (MIT-LICENSE.txt)
 *	and GPL (GPL-LICENSE.txt) licenses.
 *
 *	Built for jQuery library
 *	http://jquery.com
 *
 */
 
(function($) {

	$.fn.charCount = function(options){
		// default configuration properties
		var defaults = {
			css: 'badge',
			counterElement: 'span',
			cssWarning: 'badge-warning',
			cssExceeded: 'badge-important',
			counterText: '残り',
			text: false
		};

		var options = $.extend(defaults, options); 
		
		this.each(function() {
			$(this).closest('.controls').prev().append('<'+ options.counterElement +' class="' + options.css + '">'+ options.counterText +'</'+ options.counterElement +'>');
			var maxChars = $(this).data("maxlength");
			var warningChars = Math.floor(maxChars/10);

			function calculate(obj){
				var count;
				if(options.text){
					count = $('<div>' + $(obj).val() + '</div>').text().replace(/[\r\n]/g,"").length
				} else {
					count = $(obj).val().length;
				}
				var available = maxChars - count;
				var counterElement = $(obj).closest('.controls').prev().find(options.counterElement);
				if(available <= warningChars && available > 0){
					counterElement.addClass(options.cssWarning);
				} else {
					counterElement.removeClass(options.cssWarning);
				}
				if(available <= 0){
					counterElement.addClass(options.cssExceeded);
				} else {
					counterElement.removeClass(options.cssExceeded);
				}
				counterElement.html(options.counterText + available + "文字");
			};

			calculate(this);
			$(this).keydown(function(){calculate(this)});
			$(this).keyup(function(){calculate(this)});
			$(this).keypress(function(){calculate(this)});
			$(this).change(function(){calculate(this)});
		});
	};

})(jQuery);
