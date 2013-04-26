# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class AddNextHitrate < BaseEffect
        include Calculate
        
        def play_children
          
          timing = @tree[:timing].try(:values).try(:first)
          ant    = @tree[:ant] ? '回避率' : '命中率'
          sign   = @tree[:minus] ? '減少' : '増加'
          coeff  = @tree[:coeff_value]  ? "#{calcu_value(@tree[:coeff_value] ).call.to_i}%" : nil
          change = @tree[:change_value] ? "#{calcu_value(@tree[:change_value]).call.to_i}"  : nil
          unique = @tree[:unique]
          
          effects_type        = :temporary_effect
          effects_name        = %Q|次の#{timing}攻撃の#{ant}#{sign}|
          effects_setting     = { :name => effects_name }
          effects_definitions = <<-"DEFINITION"
[一時効果]#{effects_name}
[#{timing}#{ant}決定前]
自/{次の#{ant}#{sign}(#{[coeff, change].compact.join('/')})＋一時効果消滅}
          DEFINITION
          
          effects_definitions = [{ effects_type => DNU::Data.parse_definition(:temporary_effect, effects_definitions) }]
          
          # 重複不可でかつ既に付加追加済みの場合はもう追加しない
          unless unique and 対象.effects.find_by_name(%Q|#{effects_name}#{"LV#{effects_setting[:lv]}" if effects_setting[:lv]}|).find_by_parent(@stack.last).present?
            対象.add_effects({ effects_type => effects_setting }, @stack.last, effects_definitions)
            success = true
          end
          
          history[:children] = { :name => effects_name, :coeff => coeff, :change => change, :success => success }
          
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
