# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  namespace = $("#websocket-namespace").val()
  room = $("#websocket-room").val()
  if namespace?
    $.fn.addWaypoint = ->
      $(this).waypoint
        offset: 0
        context: "#chat"
        handler: (direction)->
          if direction == "up"
            $this = $(this)
            
            $this.waypoint 'destroy'
            
            $.get $("a[rel=next]").last().attr('href'), (data) ->
              $data = $(data)
              $more = $("a[rel=next]").last()
              $newMore = $data.find("a[rel=next]").last()
              
              scrollHeight = $("#chat").prop("scrollHeight")
              
              $items = $data.find(".chat-comment").each ->
                $input = $(this).find("input")
                data = JSON.parse($input.val())
                $input.after html_from_data(data)
              $(".chat-comment").first().before($items)
              
              newScrollHeight = $("#chat").prop("scrollHeight")
              
              $("#chat").scrollTop(newScrollHeight-scrollHeight)
              
              if $newMore.length
                $more.replaceWith $newMore
                $("#chat").find(".chat-comment").first().addWaypoint()
    
    alert_from_text = (text) ->
      $button = $("<button>").addClass("close").attr("data-dismiss", "alert").html("（・ｘ・）")
      $div = $("<div>").addClass("alert").append($button)
      $div.append text
    
    html_from_data = (data, self) ->
      tree = parser.parse(data.text, "message")
      html = textTransformer(tree.html, data.icons)
      time = data.updated_at
      $("<div>").append($("<span>").addClass("label label-success").html(if self then "自分の発言" else "ENo.#{data.eno} #{data.nickname}さんからのメッセージ")).append(time).append(html)
    
    append_html_from_data = (data, self) ->
      $div = html_from_data(data, self)
      $div.hide().appendTo("#chat").fadeIn()
      $("#chat").stop(true, false).animate scrollTop: $("#chat").prop("scrollHeight")
    
    socket = io.connect("http://dnu.dip.jp:5000/#{namespace}")
    
    socket.emit "enter",
      room: room
      eno: $("#eno").val()
      nickname: $("#nickname").val()
    
    socket.on "list", (data)->
      $list = $("<div>")
      for c in data
        $list.append($("<span>").addClass("badge").html("ENo.#{c.eno} #{c.nickname}さん"))
      $("#list").html($list)
    
    socket.on "in", (data) ->
      $("#chat").append alert_from_text("ENo.#{data.eno} #{data.nickname}さんが入室しました。")
      $("#chat").stop(true, false).animate scrollTop: $("#chat").prop("scrollHeight")
    
    socket.on "out", (data) ->
      $("#chat").append alert_from_text("ENo.#{data.eno} #{data.nickname}さんが退室しました。")
      $("#chat").stop(true, false).animate scrollTop: $("#chat").prop("scrollHeight")
    
    socket.on "message", (data) ->
      append_html_from_data data
    
    $(".chat-comment").each ->
      $input = $(this).find("input")
      data = JSON.parse($input.val())
      $input.after html_from_data(data)
    $("#chat").scrollTop $("#chat").prop("scrollHeight")
    
    is_enable = true
    $("#send").click (e) ->
      if $("#message").val() and is_enable
        is_enable = false
        data =
          eno: $("#eno").val()
          nickname: $("#nickname").val()
          text: $("#message").val()
          icons: registerIcons
        
        socket.emit "message", data
        append_html_from_data data, true
      else
        e.preventDefault()
    
    $("#message").keydown (e) ->
      if e.keyCode is 13 and e.shiftKey
        e.preventDefault()
        $("#send").click()
    
    $("body").delegate "form.chat-form", "ajax:complete", (event, xhr, status) ->
      if this == event.target
        is_enable = true
        $("#message").val("").keyup()
        console.log "form.chat-form ajax:complete"
    
    $(".pagination").hide()
    
    $("#chat").find(".chat-comment").first().addWaypoint()
