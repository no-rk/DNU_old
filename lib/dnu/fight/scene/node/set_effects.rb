# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class SetEffects < BaseScene
        
        def default_attack
          @default_attack ||= EffectTransform.new.apply(EffectParser.new.root_processes.parse("敵単/SW物魔攻撃(1.0)"))
        end
        
        # @activeが所持している技を優先順位順にif elseで繋げる
        def create_tree
          temp = []
          tree = default_attack
          while effects = @active.call.effects.type(:Skill).done_not.low_priority
            effects.off
            temp << effects
            tree = {
              :if => {
                :condition => effects.condition,
                :then => {
                  :effects => {
                    :effects => effects,
                  }
                },
                :else => tree
              }
            }
          end
          temp.each{ |effects| effects.on }
          tree
        end
        
        def before_create_children
          @tree ||= create_tree
        end
        
        def after_each_scene
          @children = nil
          @tree = nil
        end
        
        def play_(b_or_a)
        end
        
        def history
          @parent.history
        end
        
        def log_before_each_scene
          @history = @parent.try(:history) || {}
          @history = @history[:children] ||= []
        end
        
      end
    end
  end
end