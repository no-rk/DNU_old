# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class AddEffects < BaseScene
        include Calculate
        
        def play_children
          effects_type        = @tree.keys.first
          effects_setting     = @tree.values.first
          effects_name        = effects_setting[:name]
          effects_definitions = @stack.last.respond_to?(:definitions) ? @stack.last.definitions : nil
          
          # 重複不可でかつ既に付加追加済みの場合はもう追加しない
          unless effects_setting[:unique] and 対象.effects.find_by_name(%Q|#{effects_name}#{"LV#{effects_setting[:lv]}" if effects_setting[:lv]}|).find_by_parent(@stack.last).present?
            対象.add_effects(effects_type, effects_name, effects_setting, effects_definitions, @stack.last)
            success = true
          end
          
          history[:children] = { :type => effects_type.to_s.camelize.to_sym, :name => effects_name, :setting => effects_setting, :success => success }
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
