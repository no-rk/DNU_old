# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class AddReflection < BaseEffect
        include Calculate
        
        def play_children
          
          timing = @tree[:timing].try(:values).try(:first)
          repeat_value = calcu_value(@tree[:repeat_value]).call.to_i
          unique       = @tree[:unique]
          
          effects_type        = :temporary_effect
          effects_name        = %Q|次の#{timing}攻撃反射|
          effects_setting     = { :name => effects_name }
          effects_definitions = <<-"DEFINITION"
[一時効果]#{effects_name}
[#{timing}被攻撃前]次の攻撃対象未変化
敵単/{次の攻撃対象(対象)＋一時効果消滅}
          DEFINITION
          
          effects_definitions = [{ effects_type => DNU::Data.parse_definition(:temporary_effect, effects_definitions) }]
          
          # 重複不可でかつ既に付加追加済みの場合はもう追加しない
          unless unique and 対象.effects.find_by_name(%Q|#{effects_name}#{"LV#{effects_setting[:lv]}" if effects_setting[:lv]}|).find_by_parent(@stack.last).present?
            repeat_value.times{ 対象.add_effects({ effects_type => effects_setting }, @stack.last, effects_definitions) }
            success = true
          end
          
          history[:children] = { :name => effects_name, :repeat_value => repeat_value, :success => success }
          
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
