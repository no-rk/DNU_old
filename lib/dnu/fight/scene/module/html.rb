# encoding: UTF-8
module DNU
  module Fight
    module Scene
      module Html
        
        def SetBattleValue(tree)
          %Q|\n戦闘値決定| +
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
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
          tree[:active].inject("") do |t,h|
            t << "<table>\n<tr><td colspan=7>#{h.keys.first.to_s}</td></tr>\n" +
              h.values.first.inject("") do |s,n|
                s << "<tr><td>#{n[:active]}</td><td>ＨＰ#{n[:HP]}</td><td>／#{n[:MHP]}</td><td>ＭＰ#{n[:MP]}</td><td>／#{n[:MMP]}</td><td>隊列#{n[:Position]}</td><td>射程#{n[:Range]}</td></tr>\n"
              end + "</table>\n"
          end +
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
        def PrepareTurn(tree)
          %Q|\n<span class="active">#{tree[:active].first}</span>の準備ターン<br>| +
          %Q|\nHP#{tree[:HP]}/#{tree[:MHP]}<br>| +
          %Q|\nMP#{tree[:MP]}/#{tree[:MMP]}<br>| +
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
        def LeadoffTurn(tree)
          %Q|\n<span class="active">#{tree[:active].first}</span>の先制ターン<br>| +
          %Q|\nHP#{tree[:HP]}/#{tree[:MHP]}<br>| +
          %Q|\nMP#{tree[:MP]}/#{tree[:MMP]}<br>| +
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
        def Phase(tree)
          %Q|\nフェイズ#{tree[:index]}<br>| +
          tree[:active].inject("") do |t,h|
            t << "<table>\n<tr><td colspan=7>#{h.keys.first.to_s}</td></tr>\n" +
              h.values.first.inject("") do |s,n|
                s << "<tr><td>#{n[:active]}</td><td>ＨＰ#{n[:HP]}</td><td>／#{n[:MHP]}</td><td>ＭＰ#{n[:MP]}</td><td>／#{n[:MMP]}</td><td>隊列#{n[:Position]}</td><td>射程#{n[:Range]}</td></tr>\n"
              end + "</table>\n"
          end +
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
        def Turn(tree)
          %Q|\n<span class="active">#{tree[:active].first}</span>のターン<br>| +
          %Q|\nHP#{tree[:HP]}/#{tree[:MHP]}<br>| +
          %Q|\nMP#{tree[:MP]}/#{tree[:MMP]}<br>| +
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
        def Act(tree)
          %Q|\n<span class="active">#{tree[:active].first}</span>の行動| +
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
        def AddAct(tree)
          %Q|\n<span class="active">#{tree[:active].first}</span>の追加行動#{tree[:index]}| +
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
        
        def Result(tree)
          nested_div(tree[:before])   +
          (tree[:children].count==1 ? "#{tree[:children].first}の勝利！" : "引き分け。") +
          nested_div(tree[:after])
        end
        
        def DefaultAttack(tree)
          %Q|\n<span class="active">#{tree[:active].first}</span>の#{tree[:name]}！| +
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
        def Effects(tree)
          %Q|\n<span class="active">#{tree[:active].first}</span>の#{tree[:name]}！| +
          nested_div(tree[:before])   +
          nested_div(tree[:children]) +
          nested_div(tree[:after])
        end
        
        def Before(tree)
          %Q*\n<span class="active">#{tree[:active]}</span>の#{tree[:name]}（#{tree[:parent].to_s.underscore.split(/_(?!ant|val)/).map{|s|s.camelize.to_sym}.inject(""){|a,s| a << I18n.t(s, :scope => "DNU.Fight.Scene") }}前#{tree[:kind]}）* +
          nested_div(tree[:children])
        end
        
        def Children(tree)
          %Q*\n<span class="active">#{tree[:active].first}</span>の#{tree[:name]}（#{tree[:parent].to_s.underscore.split(/_(?!ant|val)/).map{|s|s.camelize.to_sym}.inject(""){|a,s| a << I18n.t(s, :scope => "DNU.Fight.Scene") }}#{I18n.t(tree[:b_or_a], :scope => "DNU.Fight.Scene")}#{tree[:kind]}）* +
          nested_div(tree[:children])
        end
        
        def After(tree)
          %Q*\n<span class="active">#{tree[:active]}</span>の#{tree[:name]}（#{tree[:parent].to_s.underscore.split(/_(?!ant|val)/).map{|s|s.camelize.to_sym}.inject(""){|a,s| a << I18n.t(s, :scope => "DNU.Fight.Scene") }}後#{tree[:kind]}）* +
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
          (h[:critical] ? "クリティカル！<br>" : "") +
          %Q|\n<span class="passive">#{tree[:passive]}</span>に#{(h[:after_change]-h[:before_change]).abs}の#{h[:attack_element]}属性#{I18n.t(h[:attack_type], :scope => "DNU.Fight.Scene")}ダメージを与えた！（ #{h[:before_change]} ⇒ #{h[:after_change]} ）| +
          nested_div(tree[:after])
        end
        
        def Miss(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          %Q|\n<span class="passive">#{tree[:passive]}</span>は#{h[:attack_element]}属性#{I18n.t(h[:attack_type], :scope => "DNU.Fight.Scene")}攻撃を回避した！| +
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
          %Q|\n<span class="passive">#{tree[:passive]}</span>に#{h[:battle_value]}を#{(h[:after_change]-h[:before_change]).abs}追加した！（ #{h[:before_change]} ⇒ #{h[:after_change]} ）| +
          nested_div(tree[:after])
        end
        
        def Resist(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          %Q|\n<span class="passive">#{tree[:passive]}</span>は#{h[:battle_value]}に抵抗した！| +
          nested_div(tree[:after])
        end
        
        def Reduce(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          %Q|\n<span class="passive">#{tree[:passive]}</span>は#{h[:battle_value]}を#{(h[:after_change]-h[:before_change]).abs}軽減した！（ #{h[:before_change]} ⇒ #{h[:after_change]} ）| +
          nested_div(tree[:after])
        end
        
        def Heal(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          %Q|\n<span class="passive">#{tree[:passive]}</span>の#{h[:battle_value]}は#{h[:change_value].abs}回復した！（ #{h[:before_change]} ⇒ #{h[:after_change]} ）| +
          nested_div(tree[:after])
        end
        
        def Up(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          %Q|\n<span class="passive">#{tree[:passive]}</span>の#{h[:battle_value]}が#{(h[:after_change]-h[:before_change]).abs}上昇した！（ #{h[:before_change]} ⇒ #{h[:after_change]} ）| +
          nested_div(tree[:after])
        end
        
        def Down(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          %Q|\n<span class="passive">#{tree[:passive]}</span>の#{h[:battle_value]}が#{(h[:after_change]-h[:before_change]).abs}低下した！（ #{h[:before_change]} ⇒ #{h[:after_change]} ）| +
          nested_div(tree[:after])
        end
        
        def Steal(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          %Q|\n<span class="passive">#{tree[:passive]}</span>の#{h[:battle_value]}を#{(h[:after_change]-h[:before_change]).abs}奪取した！（ #{h[:before_change]} ⇒ #{h[:after_change]} ）| +
          nested_div(tree[:after])
        end
        
        def Increase(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          %Q|\n<span class="passive">#{tree[:passive]}</span>の#{h[:battle_value]}が#{(h[:after_change]-h[:before_change]).abs}増加した！（ #{h[:before_change]} ⇒ #{h[:after_change]} ）| +
          nested_div(tree[:after])
        end
        
        def Decrease(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          %Q|\n<span class="passive">#{tree[:passive]}</span>の#{h[:battle_value]}が#{(h[:after_change]-h[:before_change]).abs}減少した！（ #{h[:before_change]} ⇒ #{h[:after_change]} ）| +
          nested_div(tree[:after])
        end
        
        def Rob(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          %Q|\n<span class="passive">#{tree[:passive]}</span>の#{h[:battle_value]}を#{(h[:after_change]-h[:before_change]).abs}強奪した！（ #{h[:before_change]} ⇒ #{h[:after_change]} ）| +
          nested_div(tree[:after])
        end
        
        def Convert(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          %Q|\n<span class="passive">#{tree[:passive]}</span>の#{h[:battle_value]}を#{h[:after_change]}にした！（ #{h[:before_change]} ⇒ #{h[:after_change]} ）| +
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
        
        def Vanish(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          if h[:success]
            if h[:vanish_name]
              if h[:vanish_all]
                %|\n<span class="passive">#{tree[:passive]}</span>の[#{I18n.t(h[:vanish_type], :scope => "DNU.Fight.Scene")}]#{h[:vanish_name]}#{'の設定' if h[:vanish_type]==:Skill}が全て消滅した！|
              else
                %|\n<span class="passive">#{tree[:passive]}</span>の[#{I18n.t(h[:vanish_type], :scope => "DNU.Fight.Scene")}]#{h[:vanish_name]}#{'の設定' if h[:vanish_type]==:Skill}が１つ消滅した！|
              end
            else
              if h[:type] == h[:vanish_type]
                %|\n[#{I18n.t(h[:type], :scope => "DNU.Fight.Scene")}]#{h[:name]}#{'の設定' if h[:type]==:Skill}が消滅した！|
              else
                %|\n[#{I18n.t(h[:type], :scope => "DNU.Fight.Scene")}]#{h[:name]}は#{I18n.t(h[:vanish_type], :scope => "DNU.Fight.Scene")}ではないので消滅しない。|
              end
            end
          else
            %|\n消滅の対象となる#{I18n.t(h[:vanish_type], :scope => "DNU.Fight.Scene")}は存在しない。|
          end +
          nested_div(tree[:after])
        end
        
        def ChangeSetting(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          if h[:success]
            case h[:change_setting_find].try(:to_sym)
            when :random
              %^\n<span class="passive">#{tree[:passive]}</span>の[#{I18n.t(h[:change_setting_type], :scope => "DNU.Fight.Scene")}]#{h[:change_setting_name] || h[:name]}の設定が変更された！^
            when :all
              if h[:change_setting_name].present?
                %|\n<span class="passive">#{tree[:passive]}</span>の[#{I18n.t(h[:change_setting_type], :scope => "DNU.Fight.Scene")}]#{h[:change_setting_name]}の設定が全て変更された！|
              else
                %|\n<span class="passive">#{tree[:passive]}</span>の#{I18n.t(h[:change_setting_type], :scope => "DNU.Fight.Scene")}設定が全て変更された！|
              end
            end
          else
            %|\n変更の対象となる#{I18n.t(h[:change_setting_type], :scope => "DNU.Fight.Scene")}設定は存在しない。|
          end +
          nested_div(tree[:after])
        end
        
        def AddNextAttackElement(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          if h[:success]
            %Q|\n<span class="passive">#{tree[:passive]}</span>の次の#{h[:repeat_value]}回分の攻撃が#{h[:element]}属性化！|
          else
            %Q|\n<span class="passive">#{tree[:passive]}</span>の次の#{h[:repeat_value]}回分の攻撃が#{h[:element]}属性化はもうできない。|
          end +
          nested_div(tree[:after])
        end
        
        def AddReflection(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          if h[:success]
            %Q|\n<span class="passive">#{tree[:passive]}</span>は#{h[:repeat_value]}回分の#{h[:name]}！|
          else
            %Q|\n<span class="passive">#{tree[:passive]}</span>は#{h[:repeat_value]}回分の#{h[:name]}はもうできない。|
          end +
          nested_div(tree[:after])
        end
        
        def AddNextDamage(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          if h[:success]
            %Q|\n<span class="passive">#{tree[:passive]}</span>の#{h[:name]}！（#{"割合：#{h[:coeff]}" if h[:coeff].to_i!=0}#{"固定値：#{h[:change]}" if h[:change].to_i!=0}）|
          else
            %Q|\n<span class="passive">#{tree[:passive]}</span>の#{h[:name]}はもうできない。（#{"割合：#{h[:coeff]}" if h[:coeff].to_i!=0}#{"固定値：#{h[:change]}" if h[:change].to_i!=0}）|
          end +
          nested_div(tree[:after])
        end
        
        def AddNextHitrate(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          if h[:success]
            %Q|\n<span class="passive">#{tree[:passive]}</span>の#{h[:name]}！（#{"割合：#{h[:coeff]}" if h[:coeff].to_i!=0}#{"固定値：#{h[:change]}" if h[:change].to_i!=0}）|
          else
            %Q|\n<span class="passive">#{tree[:passive]}</span>の#{h[:name]}はもうできない。（#{"割合：#{h[:coeff]}" if h[:coeff].to_i!=0}#{"固定値：#{h[:change]}" if h[:change].to_i!=0}）|
          end +
          nested_div(tree[:after])
        end
        
        def AddDiseaseProtect(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          if h[:success]
            %Q|\n<span class="passive">#{tree[:passive]}</span>の次の#{h[:repeat_value]}回分の#{I18n.t(h[:disease_name], :scope => "DNU.Fight.Scene")}防御！|
          else
            %Q|\n<span class="passive">#{tree[:passive]}</span>の次の#{h[:repeat_value]}回分の#{I18n.t(h[:disease_name], :scope => "DNU.Fight.Scene")}防御はもうできない。|
          end +
          nested_div(tree[:after])
        end
        
        def AddEffects(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          if h[:success]
            %Q|\n<span class="passive">#{tree[:passive]}</span>に[#{I18n.t(h[:type], :scope => "DNU.Fight.Scene")}]#{h[:name]}#{"LV#{h[:setting][:lv]}" if h[:setting][:lv]}を追加！|
          else
            %Q|\n<span class="passive">#{tree[:passive]}</span>に[#{I18n.t(h[:type], :scope => "DNU.Fight.Scene")}]#{h[:name]}#{"LV#{h[:setting][:lv]}" if h[:setting][:lv]}をもう追加できない！|
          end +
          nested_div(tree[:after])
        end
        
        def AddCharacter(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          if h[:success]
            %Q|\n<span class="passive">#{tree[:passive]}</span>に[#{I18n.t(h[:kind], :scope => "DNU.Fight.Scene")}]#{h[:name]}を召喚！|
          else
            %Q|\n<span class="passive">#{tree[:passive]}</span>に[#{I18n.t(h[:kind], :scope => "DNU.Fight.Scene")}]#{h[:name]}をもう召喚できない！|
          end +
          nested_div(tree[:after])
        end
        
        def AddDouble(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          if h[:success]
            %Q|\n<span class="passive">#{tree[:passive]}</span>は分身した！|
          else
            %Q|\n<span class="passive">#{tree[:passive]}</span>はもう分身できない！|
          end +
          nested_div(tree[:after])
        end
        
        def Interrupt(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          if h[:interrupt] == h[:type] and h[:success]
            %|\n[#{I18n.t(h[:type], :scope => "DNU.Fight.Scene")}]#{h[:name]}を強制中断！|
          elsif h[:interrupt] == h[:type]
            %|\n[#{I18n.t(h[:type], :scope => "DNU.Fight.Scene")}]#{h[:name]}は既に中断されている・・・！|
          else
            %|\n強制中断の対象となる#{I18n.t(h[:interrupt], :scope => "DNU.Fight.Scene")}は存在しない。|
          end +
          nested_div(tree[:after])
        end
        
        def Revive(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
          if h[:live]
            %Q|\n<span class="passive">#{tree[:passive]}</span>は生きてる。|
          else
            %Q|\n<span class="passive">#{tree[:passive]}</span>は生き返った。（ #{h[:before_change]} ⇒ #{h[:after_change]} ）|
          end +
          nested_div(tree[:after])
        end
        
        def Serif(tree)
          nested_div(tree[:before])   +
          tree[:children] +
          nested_div(tree[:after])
        end
        
        def Empty(tree)
          nested_div(tree[:before])   +
           %Q|\n#{tree[:children][:scope]}には対象が存在しない。| +
          nested_div(tree[:after])
        end
        
        def NextStatus(tree)
          h = tree[:children]
          nested_div(tree[:before])   +
           %Q|\n<span class="passive">#{h[:state_target]}</span>の次の#{h[:battle_value]}を#{h[:change_to]}にした！| +
          nested_div(tree[:after])
        end
        
        def NextTurn(tree)
          nested_div(tree[:before])   +
           %Q|\n<span class="passive">#{tree[:passive]}</span>の次のターンが変化した！| +
          nested_div(tree[:after])
        end
        
        def NextAct(tree)
          nested_div(tree[:before])   +
           %Q|\n<span class="passive">#{tree[:passive]}</span>の次の行動が変化した！| +
          nested_div(tree[:after])
        end
        
        def NextAddAct(tree)
          nested_div(tree[:before])   +
           %Q|\n<span class="passive">#{tree[:passive]}</span>の次の追加行動が変化した！| +
          nested_div(tree[:after])
        end
        
        def NextTargetSet(tree)
          nested_div(tree[:before])   +
           %Q|\n<span class="passive">#{tree[:passive]}</span>の次の対象範囲が変化した。| +
          nested_div(tree[:after])
        end
        
        def NextTarget(tree)
          nested_div(tree[:before])   +
           %Q|\n<span class="passive">#{tree[:passive]}</span>の次の対象が#{tree[:children][:target]}になった。| +
          nested_div(tree[:after])
        end
        
        def NextAttackTarget(tree)
          nested_div(tree[:before])   +
           %Q|\n<span class="passive">#{tree[:passive]}</span>の次の攻撃対象が#{tree[:children][:target]}になった。| +
          nested_div(tree[:after])
        end
        
        def NextAttackElement(tree)
          nested_div(tree[:before])   +
           %Q|\n<span class="passive">#{tree[:passive]}</span>の次の属性が#{I18n.t(tree[:children][:element], :scope => "DNU.Fight.Scene")}になった！| +
          nested_div(tree[:after])
        end
        
        def NextHitrate(tree)
          nested_div(tree[:before])   +
           %Q|\n<span class="passive">#{tree[:passive]}</span>の次の#{tree[:children][:ant].present? ? "回避" : "命中"}率が#{tree[:children][:sign]>0 ? "増加" : "減少"}した！（#{"割合：#{tree[:children][:coeff]}％" if tree[:children][:coeff]!=0}#{"固定値：#{tree[:children][:change]}" if tree[:children][:change]!=0}）| +
          nested_div(tree[:after])
        end
        
        def NextHitVal(tree)
          nested_div(tree[:before])   +
           %Q|\n<span class="passive">#{tree[:passive]}</span>の次の#{"被" if tree[:children][:ant].present?}ダメージが#{tree[:children][:sign]>0 ? "増加" : "減少"}した！（#{"割合：#{tree[:children][:coeff]}％" if tree[:children][:coeff]!=0}#{"固定値：#{tree[:children][:change]}" if tree[:children][:change]!=0}）| +
          nested_div(tree[:after])
        end
        
        def NextAddVal(tree)
          nested_div(tree[:before])   +
           %Q|\n<span class="passive">#{tree[:passive]}</span>の次の#{"被" if tree[:children][:ant].present?}追加量が#{tree[:children][:sign]>0 ? "増加" : "減少"}した！（#{"割合：#{tree[:children][:coeff]}％" if tree[:children][:coeff]!=0}#{"固定値：#{tree[:children][:change]}" if tree[:children][:change]!=0}）| +
          nested_div(tree[:after])
        end
        
        def NextHealVal(tree)
          nested_div(tree[:before])   +
           %Q|\n<span class="passive">#{tree[:passive]}</span>の次の#{"被" if tree[:children][:ant].present?}回復量が#{tree[:children][:sign]>0 ? "増加" : "減少"}した！（#{"割合：#{tree[:children][:coeff]}％" if tree[:children][:coeff]!=0}#{"固定値：#{tree[:children][:change]}" if tree[:children][:change]!=0}）| +
          nested_div(tree[:after])
        end
        
        def NextIncreaseVal(tree)
          nested_div(tree[:before])   +
           %Q|\n<span class="passive">#{tree[:passive]}</span>の次の#{"被" if tree[:children][:ant].present?}増加量が#{tree[:children][:sign]>0 ? "増加" : "減少"}した！（#{"割合：#{tree[:children][:coeff]}％" if tree[:children][:coeff]!=0}#{"固定値：#{tree[:children][:change]}" if tree[:children][:change]!=0}）| +
          nested_div(tree[:after])
        end
        
        def NextDecreaseVal(tree)
          nested_div(tree[:before])   +
           %Q|\n<span class="passive">#{tree[:passive]}</span>の次の#{"被" if tree[:children][:ant].present?}減少量が#{tree[:children][:sign]>0 ? "増加" : "減少"}した！（#{"割合：#{tree[:children][:coeff]}％" if tree[:children][:coeff]!=0}#{"固定値：#{tree[:children][:change]}" if tree[:children][:change]!=0}）| +
          nested_div(tree[:after])
        end
        
        def NextUpVal(tree)
          nested_div(tree[:before])   +
           %Q|\n<span class="passive">#{tree[:passive]}</span>の次の#{"被" if tree[:children][:ant].present?}上昇量が#{tree[:children][:sign]>0 ? "増加" : "減少"}した！（#{"割合：#{tree[:children][:coeff]}％" if tree[:children][:coeff]!=0}#{"固定値：#{tree[:children][:change]}" if tree[:children][:change]!=0}）| +
          nested_div(tree[:after])
        end
        
        def NextDownVal(tree)
          nested_div(tree[:before])   +
           %Q|\n<span class="passive">#{tree[:passive]}</span>の次の#{"被" if tree[:children][:ant].present?}低下量が#{tree[:children][:sign]>0 ? "増加" : "減少"}した！（#{"割合：#{tree[:children][:coeff]}％" if tree[:children][:coeff]!=0}#{"固定値：#{tree[:children][:change]}" if tree[:children][:change]!=0}）| +
          nested_div(tree[:after])
        end
        
        def NextStealVal(tree)
          nested_div(tree[:before])   +
           %Q|\n<span class="passive">#{tree[:passive]}</span>の次の#{"被" if tree[:children][:ant].present?}奪取量が#{tree[:children][:sign]>0 ? "増加" : "減少"}した！（#{"割合：#{tree[:children][:coeff]}％" if tree[:children][:coeff]!=0}#{"固定値：#{tree[:children][:change]}" if tree[:children][:change]!=0}）| +
          nested_div(tree[:after])
        end
        
        def NextRobVal(tree)
          nested_div(tree[:before])   +
           %Q|\n<span class="passive">#{tree[:passive]}</span>の次の#{"被" if tree[:children][:ant].present?}強奪量が#{tree[:children][:sign]>0 ? "増加" : "減少"}した！（#{"割合：#{tree[:children][:coeff]}％" if tree[:children][:coeff]!=0}#{"固定値：#{tree[:children][:change]}" if tree[:children][:change]!=0}）| +
          nested_div(tree[:after])
        end
        
        def NextReduceVal(tree)
          nested_div(tree[:before])   +
           %Q|\n<span class="passive">#{tree[:passive]}</span>の次の#{"被" if tree[:children][:ant].present?}軽減量が#{tree[:children][:sign]>0 ? "増加" : "減少"}した！（#{"割合：#{tree[:children][:coeff]}％" if tree[:children][:coeff]!=0}#{"固定値：#{tree[:children][:change]}" if tree[:children][:change]!=0}）| +
          nested_div(tree[:after])
        end
        
        def NextCostVal(tree)
          nested_div(tree[:before])   +
           %Q|\n<span class="passive">#{tree[:passive]}</span>の次の#{"被" if tree[:children][:ant].present?}消費量が#{tree[:children][:sign]>0 ? "増加" : "減少"}した！（#{"割合：#{tree[:children][:coeff]}％" if tree[:children][:coeff]!=0}#{"固定値：#{tree[:children][:change]}" if tree[:children][:change]!=0}）| +
          nested_div(tree[:after])
        end
        
        def NextConvertVal(tree)
          nested_div(tree[:before])   +
           %Q|\n<span class="passive">#{tree[:passive]}</span>の次の#{"被" if tree[:children][:ant].present?}変換量が#{tree[:children][:sign]>0 ? "増加" : "減少"}した！（#{"割合：#{tree[:children][:coeff]}％" if tree[:children][:coeff]!=0}#{"固定値：#{tree[:children][:change]}" if tree[:children][:change]!=0}）| +
          nested_div(tree[:after])
        end
        
        def nested_div(tree)
          if tree.respond_to?(:keys)
            class_name = tree.keys.first
            tree[class_name][:children].present? ? %Q|\n<div class="#{class_name}">#{try(class_name, tree[class_name])}\n</div>| : ''
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
