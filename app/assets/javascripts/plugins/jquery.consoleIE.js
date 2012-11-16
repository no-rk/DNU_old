$(function(){
  /**
  * Enable console.log() 
  * 
  * @author manji6 http://manjiro.net/
  * @licence MIT
  **/
  if (!("console" in window && "time" in window.console)){
    //表示領域を作る
    if(!$("body").has("#debugArea")){
      $("body").append("<div id='debugArea'></div>");
    }
    window.console = {};
    window.console.log = function(str){
      $('#debugArea').append('<p>' + str + '</p>');
    }
  }
});