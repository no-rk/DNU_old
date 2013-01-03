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
          %Q|\n非接触フェイズ<br>| +
          tree[:active].inject("<table>"){ |s,n| s << "<tr><td>#{n[:active]}</td><td>ＨＰ#{n[:HP]}</td><td>／#{n[:MHP]}</td><td>ＭＰ#{n[:MP]}</td><td>／#{n[:MMP]}</td><td>隊列#{n[:Position]}</td><td>射程#{n[:Range]}</td></tr>" } + "</table>" +
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
        def Phase(tree)
          %Q|\nフェイズ#{tree[:index]}<br>| +
          tree[:active].inject("<table>"){ |s,n| s << "<tr><td>#{n[:active]}</td><td>ＨＰ#{n[:HP]}</td><td>／#{n[:MHP]}</td><td>ＭＰ#{n[:MP]}</td><td>／#{n[:MMP]}</td><td>隊列#{n[:Position]}</td><td>射程#{n[:Range]}</td></tr>" } + "</table>" +
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
          %Q|\n<span class="active">#{tree[:active]}</span>の追加行動#{tree[:index]}| +
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
        def Cemetery(tree)
          nested_div(tree[:before])   +
          tree[:children].inject(""){ |s,n| s << "#{n}は墓地に送られた！<br>" } +
          nested_div(tree[:after])
        end
        
        def Formation(tree)
          nested_div(tree[:before])   +
          tree[:children].inject(""){ |s,n| s << "#{n}は隊列を整えた！<br>" } +
          nested_div(tree[:after])
        end
        
        def Effects(tree)
          %Q|\n<span class="active">#{tree[:active]}</span>の#{tree[:name]}！| +
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
        def Before(tree)
          %Q|\n<span class="active">#{tree[:active]}</span>の#{tree[:name]}「#{I18n.t(tree[:parent], :scope => "DNU.Fight.Scene")}前#{I18n.t(tree[:type], :scope => "DNU.Fight.Scene")}」| +
          nested_div(tree[:children])
        end
        
        def After(tree)
          %Q|\n<span class="active">#{tree[:active]}</span>の#{tree[:name]}「#{I18n.t(tree[:parent], :scope => "DNU.Fight.Scene")}後#{I18n.t(tree[:type], :scope => "DNU.Fight.Scene")}」| +
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
          %Q|\n<span class="passive">#{tree[:passive]}</span>に#{(h[:after_change]-h[:before_change]).abs}の#{h[:element]}属性#{h[:attack_type]}ダメージを与えた！（ #{h[:before_change]} ⇒ #{h[:after_change]} ）| +
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
          h = tree[:children]
          nested_div(tree[:before])   +
          %Q|\n<span class="passive">#{tree[:passive]}</span>に#{I18n.t(h[:disease_name], :scope => "DNU.Fight.Scene")}を#{(h[:after_change]-h[:before_change]).abs}追加した！（ #{h[:before_change]} ⇒ #{h[:after_change]} ）| +
          nested_div(tree[:after])
        end
        
        def Resist(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          %Q|\n<span class="passive">#{tree[:passive]}</span>は#{I18n.t(h[:disease_name], :scope => "DNU.Fight.Scene")}に抵抗した！| +
          nested_div(tree[:after])
        end
        
        def Reduce(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          %Q|\n<span class="passive">#{tree[:passive]}</span>は#{I18n.t(h[:disease_name], :scope => "DNU.Fight.Scene")}を#{(h[:after_change]-h[:before_change]).abs}軽減した！（ #{h[:before_change]} ⇒ #{h[:after_change]} ）| +
          nested_div(tree[:after])
        end
        
        def Heal(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          %Q|\n<span class="passive">#{tree[:passive]}</span>の#{h[:status_name]}は#{h[:change].abs}回復した！（ #{h[:before_change]} ⇒ #{h[:after_change]} ）| +
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
        
        def CostUp(tree)
          h = tree[:children]
          h[:skill_name] = h[:skill_name].nil? ? "全技" : "[技]#{h[:skill_name]}"
          nested_div(tree[:before])   +
          if h[:success]
            %Q|\n<span class="passive">#{tree[:passive]}</span>の#{h[:skill_name]}の消費が#{h[:change].abs}増加した！|
          else
            %Q|\n消費増加の対象となる技は存在しない。|
          end +
          nested_div(tree[:after])
        end
        
        def CostDown(tree)
          h = tree[:children]
          h[:skill_name] = h[:skill_name].nil? ? "全技" : "[技]#{h[:skill_name]}"
          nested_div(tree[:before])   +
          if h[:success]
            %Q|\n<span class="passive">#{tree[:passive]}</span>の#{h[:skill_name]}の消費が#{h[:change].abs}減少した！|
          else
            %Q|\n消費増加の対象となる技は存在しない。|
          end +
          nested_div(tree[:after])
        end
        
        def Cost(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          %Q|\n消費#{(h[:after_change]-h[:before_change]).abs}（ #{h[:before_change]} ⇒ #{h[:after_change]} ）| +
          nested_div(tree[:after])
        end
        
        def Interrupt(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          if h[:interrupt] == h[:type]
            %|\n[#{I18n.t(h[:type], :scope => "DNU.Fight.Scene")}]#{h[:name]}を強制中断！|
          else
            %|\n強制中断の対象となる#{I18n.t(h[:interrupt], :scope => "DNU.Fight.Scene")}は存在しない。|
          end +
          nested_div(tree[:after])
        end
        
        def Serif(tree)
          nested_div(tree[:before])   +
           %Q|\n#{tree[:children].to_s.gsub(/<target>/,tree[:passive])}| +
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
