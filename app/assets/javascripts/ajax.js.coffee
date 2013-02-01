# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $.fn.helpLink = () ->
    this.each ->
      help = $('<a>')
      help.attr(
        "href": $(this).data("help-path")
        "data-remote": true
        "data-params": $(this).data('params')
        "data-type": "json"
        "data-html": true
        "data-trigger": "manual"
        "rel": "popover"
      ).html('<i class="icon-search"></i>')
      help.hide() unless $(this).data('params')
      help.popover()
      $(this).after(help)

  $.fn.noAjax = ->
    this.each ->
      #もうAjaxしないようにする
      $(this).removeAttr("data-remote")
      $(this).removeData("remote")
      #ポップオーバーをトグルするためだけのリンクにする
      $(this).unbind("click").bind "click", (event) ->
        #リンク先に移動したりサブミットするなどの機能を失わせる
        event.preventDefault()
        if $(this).data("popover").$tip? && $(this).data("popover").$tip.hasClass("in")
          $(this).popover('hide')
        else
          $(this).popover('show')
          $(this).data("popover").$tip.find('a[rel*=popover]').popover()
        console.log("a click")
      console.log("no ajax")

  #ローディング表示
  $(document).bind("ajaxSend", ->
    $("*[data-ajax-loading]").show()
  ).bind("ajaxComplete", ->
    setTimeout ->
      $("*[data-ajax-loading]").hide()
    ,500
  )

  #ヘルプリンク追加
  $('*[data-help-path]').helpLink()
  #リンクヘルプ
  $('body.register,.rule').delegate 'a[data-remote]', 'ajax:success', (event, data, status, xhr) ->
    #親要素のajax:successイベントが実行されないように伝播を止める
    event.stopPropagation()
    #ポップオーバーで表示されるデータ書き換える
    img = if data.img_path? then '<img src="' + data.img_path + '" class="img-polaroid icon">' else ""
    $html = $('<div>').html(img + data.caption)
    $(this).attr({
      "data-original-title": data.model + "::" + data.name
      "data-content": $html.html()
    })
    $(this).data({
      "original-title": data.model + "::" + data.name
      "content": $html.html()
    })
    #もうAjaxしないようにする
    $(this).noAjax()
    #クリックイベントはjquery_ujs.jsで止められているのでココで再発火しておく
    $(this).click()
    console.log('a[data-remote] ajax:success')

  #セレクトヘルプ
  $('body.register').delegate 'select[data-remote]', 'ajax:before', (event) ->
    #親要素のajax:beforeイベントが実行されないように伝播を止める
    event.stopPropagation()
    next = $(this).next('a')
    if $(this).val()
      #Ajaxに渡すパラメータを選択された値に応じて設定する
      $(this).attr("data-params","id=" + $(this).val())
      $(this).data("params","id=" + $(this).val())
      console.log('select[data-remote] ajax:before')
    else
      #値がないのでAjaxキャンセル
      next = $(this).next('a')
      next.popover("hide")
      next.hide()
      console.log('select[data-remote] ajax:before cancel')
      false
  $('body.register').delegate 'select[data-remote]', 'ajax:success', (event, data, status, xhr) ->
    #親要素のajax:successイベントが実行されないように伝播を止める
    event.stopPropagation()
    #Ajaxにパラメーターを渡し終わったので消しておく
    $(this).removeAttr("data-params")
    $(this).removeData("params")
    #セレクト要素の次にあるリンクヘルプを取得
    next = $(this).next('a')
    next.show()
    #ポップオーバーで表示されるデータ書き換える
    img = if data.img_path? then '<img src="' + data.img_path + '" class="img-polaroid icon">' else ""
    $html = $('<div>').html(img + data.caption)
    next.attr({
      "data-original-title": data.model + "::" + data.name
      "data-content": $html.html()
    })
    next.data({
      "original-title": data.model + "::" + data.name
      "content": $html.html()
    })
    #もうAjaxしないようにする
    next.noAjax() if next.data("remote")
    #ポップオーバー表示されてるときは再表示して内容更新
    if next.data("popover").$tip? && next.data("popover").$tip.hasClass("in")
      next.popover('show')
      next.data("popover").$tip.find('a[rel*=popover]').popover()
    console.log('select[data-remote] ajax:success')

  #ボタン確認
  $('body.register').delegate 'button[data-remote]', 'click.rails', (event) ->
    #リンク先に移動したりサブミットするなどの機能を失わせる
    event.preventDefault()
    #親要素のフォームを取得
    form = $(this).parents('form:first')
    #一時的にフォームをAjaxにする
    form.attr("data-remote",true)
    form.data("remote",true)
    #Ajaxのデータタイプをhtmlにする
    form.attr("data-type","html")
    form.data("type","html")
    #フォーム送信
    form.submit()
    #一時データー削除
    form.removeAttr("data-remote")
    form.removeData("remote")
    form.removeAttr("data-type")
    form.removeData("type")
    console.log('button[data-remote] click.rails')
  #フォーム差分チェック
  $('body.register').delegate 'form:not(.no_diff) :input', 'change.rails', (event) ->
    #親要素のフォームを取得
    form = $(this).parents('form:first')
    #一時的にフォームをAjaxにする
    form.attr("data-remote",true)
    form.data("remote",true)
    #Ajaxのデータタイプをjsonにする
    form.attr("data-type","json")
    form.data("type","json")
    #フォーム送信
    form.submit()
    #一時データー削除
    form.removeAttr("data-remote")
    form.removeData("remote")
    form.removeAttr("data-type")
    form.removeData("type")
    console.log('form:not(.no_diff) :input change.rails')
  #フォーム
  $('body.register').delegate 'form', 'ajax:success', (event, data, status, xhr) ->
    #親要素のajax:successイベントが実行されないように伝播を止める
    event.stopPropagation()
    #データタイプがhtmlだったら
    if($.type(data) == "string")
      $html = $(data)
      $html.find('*[data-help-path]').helpLink()
      $html.find('a[rel*=tooltip]').tooltip()
      $(this).after('<div class="alert"></div>')
      $(this).next('div').html($html)
      $(this).next('div').prepend('<button type="button" class="close" data-dismiss="alert">（・×・）</button><br />')
    #データタイプがjsonだったら
    else
      $('*[data-errors]').removeClass("badge badge-important").empty().css({ position: "fixed", bottom: 0, right: 0 })
      #登録内容に変更があったら
      $('*[data-errors]').addClass("badge badge-important").append("変更された。") if data.change
      #登録内容にエラーがあれば
      $('*[data-errors]').addClass("badge badge-important").append("エラーが" + data.errors.length + "つ。") if data.errors.length
      for error in data.errors
        $('*[data-errors]').append("<br />" + error)
      console.log(data)
    console.log('form ajax:success')
