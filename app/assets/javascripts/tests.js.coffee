# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  namespace = $("#websocketConnect").val()
  if namespace?
    alert_from_text = (text)->
      $button = $("<button>").addClass("close").attr("data-dismiss", "alert").html("（・ｘ・）")
      $div = $("<div>").addClass("alert").append($button)
      $div.append(text)
    
    html_from_data = (data, self)->
      tree = parser.parse(data.text, "message")
      html = textTransformer(tree.html, data.icons)
      $div = $("<div>").append($("<span>").addClass("label label-success").html(if self then "自分の発言" else "ENo.#{data.eno} #{data.nickname}さんからのメッセージ")).append(html)
      $div.hide().appendTo("#chat").fadeIn()
      $("#chat").scrollTop($("#chat").get(0).scrollHeight)
    
    socket = io.connect("http://dnu.dip.jp:5000/#{namespace}")
    
    socket.emit "enter", { eno: $("#eno").val(), nickname: $("#nickname").val() }
    
    socket.on "list", (data)->
      $list = $("<div>")
      for c in data
        $list.append($("<span>").addClass("badge").html("ENo.#{c.eno} #{c.nickname}さん"))
      $("#list").html($list)
    
    socket.on "in", (data)->
      $("#chat").append(alert_from_text("ENo.#{data.eno} #{data.nickname}さんが入室しました。"))
      $("#chat").scrollTop($("#chat").get(0).scrollHeight)
    
    socket.on "out", (data)->
      $("#chat").append(alert_from_text("ENo.#{data.eno} #{data.nickname}さんが退室しました。"))
      $("#chat").scrollTop($("#chat").get(0).scrollHeight)
    
    socket.on "message", (data)->
      html_from_data(data)
    
    $("#send").click ->
      if $("#message").val()
        data =
          eno:      $("#eno").val()
          nickname: $("#nickname").val()
          text:     $("#message").val()
          icons:    registerIcons
        $("#message").val("").keyup()
        socket.emit "message", data
        html_from_data(data, true)
    
    $("#message").keydown (e)->
      if e.keyCode==13 and e.shiftKey
        e.preventDefault()
        $("#send").click()
