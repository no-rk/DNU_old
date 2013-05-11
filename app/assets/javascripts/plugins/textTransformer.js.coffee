transform = (tree) ->
  map_inners = (inners) ->
    inners.map (inner,index) ->
      transform(inner)
  switch tree.tag
    when undefined
      tree
    when 'string', 'message', 'document', 'element'
      map_inners(tree.inner).join('')
    when 'column_2', 'column_3', 'align_left', 'align_right', 'align_center', 'align_justify'
      "<div class='#{tree.tag}'>#{map_inners(tree.inner).join('')}</div>"
    when 'serif'
      if tree.data.icon
        "<div class='serif #{tree.data.position}'><div class='icon'><div class='icon_test'>#{tree.data.icon}</div></div><div class='balloon #{tree.data.balloon}'>#{map_inners(tree.inner).join('')}</div></div>"
      else
        "<div class='serif #{tree.data.position}'><div class='balloon #{tree.data.balloon}'>#{map_inners(tree.inner).join('')}</div></div>"
    when 'color'
      "<font color='#{tree.data.color}'>#{map_inners(tree.inner).join('')}</font>"
    when 'random'
      "【#{map_inners(tree.inner).join('】または【')}】"
    when 'sequence'
      "【#{map_inners(tree.inner).join('】⇒【')}】"
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
