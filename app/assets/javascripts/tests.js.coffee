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
      $("#chat").append($("<span>").addClass("label label-success").html(if self then "自分の発言" else "ENo.#{data.eno} #{data.nickname}さんからのメッセージ")).append(html).scrollTop($("#chat").get(0).scrollHeight)
    
    socket = io.connect("http://dnu.dip.jp:5000/#{namespace}")
    
    socket.emit "enter", { eno: $("#eno").val(), nickname: $("#nickname").val() }
    
    socket.on "list", (data)->
      $list = $("<div>")
      for c in data
        $list.append($("<span>").addClass("badge").html("ENo.#{c.eno} #{c.nickname}さん"))
      $("#list").html($list)
    
    socket.on "in", (data)->
      $("#chat").append(alert_from_text("ENo.#{data.eno} #{data.nickname}さんが入室しました。"))
    
    socket.on "out", (data)->
      $("#chat").append(alert_from_text("ENo.#{data.eno} #{data.nickname}さんが退室しました。"))
    
    socket.on "message", (data)->
      html_from_data(data)
    
    $("#send").click ->
      if $("#message").val()
        data =
          eno:      $("#eno").val()
          nickname: $("#nickname").val()
          text:     $("#message").val()
          icons:    registerIcons
        $("#message").val("")
        socket.emit "message", data
        html_from_data(data, true)
