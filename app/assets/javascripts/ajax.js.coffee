# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  #リンクヘルプ
  $('body.register,.rule').delegate 'a[data-remote]', 'ajax:success', (event, data, status, xhr) ->
    #親要素のajax:successイベントが実行されないように伝播を止める
    event.stopPropagation()
    #もうAjaxしないようにする
    $(this).removeAttr("data-remote")
    $(this).removeData("remote")
    #ポップオーバーで表示されるデータ書き換える
    $(this).attr({
      "data-original-title": data.model + "::" + data.name
      "data-content": data.caption
    })
    $(this).data({
      "original-title": data.model + "::" + data.name
      "content": data.caption
    })
    #ポップオーバーをトグルするためだけのリンクにする
    $(this).unbind("click").bind "click", (event) ->
      #リンク先に移動したりサブミットするなどの機能を失わせる
      event.preventDefault()
      $(this).popover('toggle')
      console.log("a click")
    #クリックイベントはjquery_ujs.jsで止められているのでココで再発火しておく
    $(this).click()
    console.log('a[data-remote] ajax:success')

  #セレクトヘルプ
  $('body.register').delegate 'select[data-remote]', 'ajax:before', (event) ->
    #親要素のajax:beforeイベントが実行されないように伝播を止める
    event.stopPropagation()
    #Ajaxに渡すパラメータを選択された値に応じて設定する
    $(this).attr("data-params","id=" + $(this).val())
    $(this).data("params","id=" + $(this).val())
    console.log('select[data-remote] ajax:before')
  $('body.register').delegate 'select[data-remote]', 'ajax:success', (event, data, status, xhr) ->
    #親要素のajax:successイベントが実行されないように伝播を止める
    event.stopPropagation()
    #Ajaxにパラメーターを渡し終わったので消しておく
    $(this).removeAttr("data-params")
    $(this).removeData("params")
    #セレクト要素の次にあるリンクヘルプを取得
    next = $(this).next('a')
    #Ajaxに渡すパラメータを設定する
    next.attr("data-params","id=" + data.id)
    next.data("params","id=" + data.id)
    #ポップオーバーで表示されるデータ書き換える
    next.attr({
      "data-original-title": data.model + "::" + data.name
      "data-content": data.caption
    })
    next.data({
      "original-title": data.model + "::" + data.name
      "content": data.caption
    })
    #ポップオーバー表示されてるときは再表示して内容更新
    next.popover("show") if next.data("popover").$tip? && next.data("popover").$tip.hasClass("in")
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
      $(this).after('<div class="alert"></div>')
      $(this).next('div').html(data)
      $(this).next('div').prepend('<button type="button" class="close" data-dismiss="alert">（・×・）</button><br />')
    #データタイプがjsonだったら
    else
      $('span.pull-right').removeClass("badge badge-important").empty()
      #登録内容に変更があったら
      $('span.pull-right').addClass("badge badge-important").append("変更された。") if data.change
      #登録内容にエラーがあれば
      $('span.pull-right').addClass("badge badge-important").append("エラーが" + data.error + "つある。") if data.error != 0
      console.log(data)
    console.log('form ajax:success')