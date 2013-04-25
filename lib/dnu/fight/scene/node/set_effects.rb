# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class SetEffects < BaseScene
        
        def default_default_attack
          @default_default_attack ||= DNU::Fight::State::DefaultAttack.new({
            :effects => [ { :do => DNU::Data.parse(:root_processes, "敵単/SW物魔攻撃(1.0)") } ]
          }).first
        end
        
        def default_attack
          @active.call.effects.type(:Weapon).sample.try(:default_attack) || default_default_attack
        end
        
        # @activeが所持している技を優先順位順にif elseで繋げる
        def create_tree
          temp = []
          tree = {
                   :default_attack => {
                     :effects => default_attack
                   }
                 }
          while effects = @active.call.effects.type(:Skill).phase.done_not.low_priority
            effects.off
            temp << effects
            tree = {
              :if => {
                :condition => effects.condition,
                :then => {
                  :effects => {
                    :effects => effects
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
