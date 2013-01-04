# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Vanish < BaseScene
        include Calculate
        
        def play_children
          effects_type = @stack.last.try(:type)
          effects_name = @stack.last.try(:name)
          vanish_type  = @tree.keys.first.to_s.camelize.to_sym
          vanish_name  = @tree.values.first[:name].try(:to_sym)
          
          if vanish_name
            success = 対象.remove_effects(対象.effects.type(vanish_type).find_by_name(vanish_name))
          else
            # 現在発動中の効果を消滅
            if effects_type == vanish_type
              success = 自分.remove_effects(自分.effects.type(vanish_type).find_by_id(@stack.last.id))
            end
          end
          
          history[:children] = { :type => effects_type, :name => effects_name, :vanish_type => vanish_type, :vanish_name => vanish_name, :success => success }
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
