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
			counterText: ''
		};

		var options = $.extend(defaults, options); 
		
		this.each(function() {
			$(this).after('<'+ options.counterElement +' class="' + options.css + '">'+ options.counterText +'</'+ options.counterElement +'>');
			var maxChars = $(this).attr("maxlength");
			var warningChars = Math.floor(maxChars/10);

			function calculate(obj){
				var count = $(obj).val().length;
				var available = maxChars - count;
				if(available <= warningChars && available > 0){
					$(obj).next().addClass(options.cssWarning);
				} else {
					$(obj).next().removeClass(options.cssWarning);
				}
				if(available <= 0){
					$(obj).next().addClass(options.cssExceeded);
				} else {
					$(obj).next().removeClass(options.cssExceeded);
				}
				$(obj).next().html(options.counterText + count + '/' + maxChars);
			};

			calculate(this);
			$(this).keydown(function(){calculate(this)});
			$(this).keyup(function(){calculate(this)});
			$(this).keypress(function(){calculate(this)});
			$(this).change(function(){calculate(this)});
		});
	};

})(jQuery);
