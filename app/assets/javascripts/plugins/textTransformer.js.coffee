transform = (tree, icons = {}) ->
  map_inners = (inners) ->
    inners.map (inner,index) ->
      transform(inner, icons)
  list_inners = (inners) ->
    list = "<li><span>"
    for inner in inners
      if inner.tag == "br"
        list += "</span></li><li><span>"
      else
        list += transform(inner, icons)
    list += "</span></li>"
    list
  switch tree.tag
    when undefined
      tree
    when 'string', 'message', 'document', 'element'
      map_inners(tree.inner).join('')
    when 'column_2', 'column_3', 'align_left', 'align_right', 'align_center', 'align_justify'
      if tree.data.color?
        "<div class='#{tree.tag}' style='background-color: #{tree.data.color};'>#{map_inners(tree.inner).join('')}</div>"
      else
        "<div class='#{tree.tag}'>#{map_inners(tree.inner).join('')}</div>"
    when 'serif'
      if tree.data.icon
        "<div class='serif #{tree.data.position}'><img class='icon' src='#{icons[tree.data.icon] || icons[1]}'><div class='balloon #{tree.data.balloon}'>#{map_inners(tree.inner).join('')}</div></div>"
      else
        "<div class='serif #{tree.data.position}'><div class='balloon #{tree.data.balloon}'>#{map_inners(tree.inner).join('')}</div></div>"
    when 'list'
      "<pre class='prettyprint linenums'><ol class='linenums'>#{list_inners(tree.inner)}</ol></pre>"
    when 'color'
      "<font color='#{tree.data.color}'>#{map_inners(tree.inner).join('')}</font>"
    when 'random'
      "【#{map_inners(tree.inner).join('】または【')}】"
    when 'sequence'
      "【#{map_inners(tree.inner).join('】⇒【')}】"
    when 'self'
      "【自分の愛称】"
    when 'target'
      "【対象の愛称】"
    when 'dice'
      "【#{tree.data.number}面ダイスを#{tree.data.count}個振った合計値】"
    when 'br'
      "<br>"
    when 'ruby', 'rb'
      "<span class='#{tree.tag}'>#{map_inners(tree.inner).join('')}</span>"
    when 'rt'
      "<span class='rp'>(</span><span class='#{tree.tag}'>#{map_inners(tree.inner).join('')}</span><span class='rp'>)</span>"
    else
      "<#{tree.tag}>#{map_inners(tree.inner).join('')}</#{tree.tag}>"
@textTransformer = transform
