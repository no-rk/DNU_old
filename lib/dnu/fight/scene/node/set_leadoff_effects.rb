# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class SetLeadoffEffects < BaseScene
        
        # @activeが所持している非接触技を優先順位順にsequenceで繋げる
        def create_tree
          temp = []
          tree = { :sequence => [] }
          while effects = @active.call.effects.type(:Skill).timing(:PrePhase).children.pre_phasable.leadoff.done_not.high_priority
            effects.off
            temp << effects
            tree[:sequence] << {
              :if => {
                :condition => effects.condition,
                :then => {
                  :effects => {
                    :effects => effects
                  }
                }
              }
            }
          end
          temp.each{ |effects| effects.on }
          # 敵に効果を及ぼす技はmax_leadoff回まで
          max_leadoff = 1
          tree[:sequence] = tree[:sequence].slice(0..(max_leadoff-1))
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
