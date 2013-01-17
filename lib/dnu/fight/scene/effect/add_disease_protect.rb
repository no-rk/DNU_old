# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class AddDiseaseProtect < BaseEffect
        include Calculate
        
        def play_children
          
          repeat_value = calcu_value(@tree[:repeat_value]).call.to_i
          disease_name = @tree[:disease_name].values.first.to_s
          unique       = @tree[:unique]
          
          effects_type        = :temporary_effect
          effects_setting     = {}
          effects_name        = %Q|#{disease_name}防御|
          effects_definitions = <<-"DEFINITION"
[一時効果]#{effects_name}
[#{disease_name}被追加量決定前]直後追加量1以上
自/{次の被追加量減少(1)＋一時効果消滅}
          DEFINITION
          
          parser    = EffectParser.new
          transform = EffectTransform.new
          effects_definitions = [{ effects_type => transform.apply(parser.temporary_effect_definition.parse(effects_definitions)) }]
          
          # 重複不可でかつ既に付加追加済みの場合はもう追加しない
          unless unique and 対象.effects.find_by_name(%Q|#{effects_name}#{"LV#{effects_setting[:lv]}" if effects_setting[:lv]}|).find_by_parent(@stack.last).present?
            repeat_value.times{ 対象.add_effects(effects_type, effects_name, effects_setting, effects_definitions, @stack.last) }
            success = true
          end
          
          history[:children] = { :disease_name => @tree[:disease_name].keys.first, :repeat_value => repeat_value, :success => success }
          
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
