# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class AddNextDamage < BaseEffect
        include Calculate
        
        def play_children
          
          timing = @tree[:timing].try(:values).try(:first)
          ant    = @tree[:ant] ? '被' : ''
          sign   = @tree[:minus] ? '減少' : '増加'
          coeff  = @tree[:coeff_value]  ? "#{calcu_value(@tree[:coeff_value] ).call.to_i}%" : nil
          change = @tree[:change_value] ? "#{calcu_value(@tree[:change_value]).call.to_i}"  : nil
          unique = @tree[:unique]
          
          effects_type        = :temporary_effect
          effects_name        = %Q|次#{ant.present? ? "に受ける" : "に与える"}#{timing}ダメージ#{sign}|
          effects_setting     = { :name => effects_name }
          effects_definitions = <<-"DEFINITION"
[一時効果]#{effects_name}
[#{timing}#{ant}ダメージ決定前]
自/{次の#{ant}ダメージ#{sign}(#{[coeff, change].compact.join('/')})＋一時効果消滅}
[#{timing}攻撃#{ant.present? ? "回避" : "空振" }後]
自/一時効果消滅
          DEFINITION
          
          effects_definitions = [{ effects_type => DNU::Data.parse_definition(:temporary_effect, effects_definitions) }]
          
          # 重複不可でかつ既に付加追加済みの場合はもう追加しない
          unless unique and 対象.effects.find_by_name(effects_name).find_by_parent(@stack.last).present?
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
