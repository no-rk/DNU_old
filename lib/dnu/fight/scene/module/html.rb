# encoding: UTF-8
module DNU
  module Fight
    module Scene
      module Html
        
        def Battle(tree)
          %Q|\n通常戦| +
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
        def Duel(tree)
          %Q|\n手合わせ| +
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
        def Competition(tree)
          %Q|\n闘技大会| +
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
        def PrePhase(tree)
          %Q|\n非接触フェイズ| +
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
        def Phase(tree)
          %Q|\nフェイズ| +
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
        def Turn(tree)
          %Q|\n<span class="active">#{tree[:active]}</span>のターン| +
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
        def Act(tree)
          %Q|\n<span class="active">#{tree[:active]}</span>の行動| +
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
        def AddAct(tree)
          %Q|\n<span class="active">#{tree[:active]}</span>の追加行動| +
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
        def Cemetery(tree)
          nested_div(tree[:before])   +
          tree[:children].inject(""){ |s,n| s << n + "は墓地に送られた！<br>" } +
          nested_div(tree[:after])
        end
        
        def Effects(tree)
          %Q|\n<span class="active">#{tree[:active]}</span>の技効果| +
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
        def Before(tree)
          %Q|\n<span class="active">#{tree[:active]}</span>の#{tree[:parent]}前効果| +
          nested_div(tree[:children])
        end
        
        def After(tree)
          %Q|\n<span class="active">#{tree[:active]}</span>の#{tree[:parent]}後効果| +
          nested_div(tree[:children])
        end
        
        def Attack(tree)
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
        def Hit(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          %Q|\n<span class="passive">#{tree[:passive]}</span>は#{(h[:after_change]-h[:before_change]).abs}の#{h[:element]}属性#{h[:attack_type]}ダメージを受けた！（ #{h[:before_change]} ⇒ #{h[:after_change]} ）| +
          nested_div(tree[:after])
        end
        
        def Miss(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          %Q|\n<span class="passive">#{tree[:passive]}</span>は#{h[:element]}属性#{h[:attack_type]}攻撃を回避した！| +
          nested_div(tree[:after])
        end
        
        def Disease(tree)
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
        def Add(tree)
          %Q|\n<span class="passive">#{tree[:passive]}</span>は| +
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
        def Resist(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          %Q|\n<span class="passive">#{tree[:passive]}</span>は#{h[:disease_name]}に抵抗した！| +
          nested_div(tree[:after])
        end
        
        def Heal(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          %Q|\n<span class="passive">#{tree[:passive]}</span>は#{(h[:change]).abs}回復した！（ #{h[:before_change]} ⇒ #{h[:after_change]} ）| +
          nested_div(tree[:after])
        end
        
        def Up(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          %Q|\n<span class="passive">#{tree[:passive]}</span>の#{h[:status_name]}が#{(h[:after_change]-h[:before_change]).abs}上昇した！（ #{h[:before_change]} ⇒ #{h[:after_change]} ）| +
          nested_div(tree[:after])
        end
        
        def Down(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          %Q|\n<span class="passive">#{tree[:passive]}</span>の#{h[:status_name]}が#{(h[:after_change]-h[:before_change]).abs}低下した！（ #{h[:before_change]} ⇒ #{h[:after_change]} ）| +
          nested_div(tree[:after])
        end
        
        def Increase(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          %Q|\n<span class="passive">#{tree[:passive]}</span>の#{h[:status_name]}が#{(h[:after_change]-h[:before_change]).abs}増加した！（ #{h[:before_change]} ⇒ #{h[:after_change]} ）| +
          nested_div(tree[:after])
        end
        
        def Decrease(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          %Q|\n<span class="passive">#{tree[:passive]}</span>の#{h[:status_name]}が#{(h[:after_change]-h[:before_change]).abs}減少した！（ #{h[:before_change]} ⇒ #{h[:after_change]} ）| +
          nested_div(tree[:after])
        end
        
        def Reduce(tree)
          %Q|\n<span class="passive">#{tree[:passive]}</span>は| +
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
        def nested_div(tree)
          if tree.respond_to?(:keys)
            class_name = tree.keys.first
            %Q|\n<div class="#{class_name}">#{try(class_name, tree[class_name])}\n</div>|
          elsif tree.respond_to?(:inject)
            tree.inject(""){|s,v| s + nested_div(v) }
          else
            %Q|#{tree}|
          end
        end
        
        def to_html
          nested_div(self)
        end
        
      end
    end
  end
end
