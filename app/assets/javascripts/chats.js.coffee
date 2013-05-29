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
            
            url = $("a[rel=next]").last().attr('href')
            if url?
              $.get url, (data) ->
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
    
    socket.on "connect", ->
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
    
    # 物理演算エンジンで遊ぶ
    phys = io.connect("http://dnu.dip.jp:5000/phys")
    
    phys.on "socket_id", (data) ->
      phys.id = data
    
    [canvas_w, canvas_h] = [800, 600]
    $("#new_chat").after("<canvas id=\"canvas\" width=\"#{canvas_w}\" height=\"#{canvas_h}\"></canvas>")
    $canvas = $("#canvas").css("user-select": "none")
    
    phys.on "world", (data)->
      c =$canvas[0].getContext('2d')
      c.clearRect(0,0,canvas_w,canvas_h)
      for bd in data[0]
        [cx, cy, r, th, hp, id] = bd
        c.moveTo(0, 0)
        c.beginPath()
        c.strokeStyle = "rgba(200, 90, 90, 0.8)"
        c.fillStyle   = "rgba(200, 90, 90, 0.5)"
        c.arc(cx, cy, r, 0, Math.PI * 2, true)
        c.moveTo(cx, cy)
        th = Math.PI*th/180
        c.lineTo((cx + r*Math.cos(th)), (cy + r*Math.sin(th)))
        c.closePath()
        c.fill()
        c.stroke()
        c.fillStyle = "black"
        c.fillText(hp, cx, cy) if hp?
        c.fillText("↓自分", cx-10, cy-40) if id == phys.id
      for bd in data[1]
        c.beginPath()
        c.strokeStyle = "rgba(90, 200, 90, 0.8)"
        c.fillStyle   = "rgba(90, 200, 90, 0.5)"
        c.moveTo(bd[0], bd[1])
        c.lineTo(bd[2], bd[3])
        c.lineTo(bd[4], bd[5])
        c.lineTo(bd[6], bd[7])
        c.closePath()
        c.fill()
        c.stroke()
        c.fillStyle = "black"
        c.fillText(bd[8], (bd[0]+bd[2]+bd[4]+bd[6])/4, (bd[1]+bd[3]+bd[5]+bd[7])/4) if bd[8]?
        c.fillText("↓自分", (bd[0]+bd[2]+bd[4]+bd[6])/4-10, (bd[1]+bd[3]+bd[5]+bd[7])/4-40) if bd[9] == phys.id
    
    $canvas.click (e)->
      phys.emit "apply_force", [e.pageX-$(this).offset().left, e.pageY-$(this).offset().top]
