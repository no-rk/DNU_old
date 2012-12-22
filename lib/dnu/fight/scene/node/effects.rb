# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Effects < BaseScene
        
        def when_initialize
          @effects = { ("effects" + self.object_id.to_s).to_sym => nil }
        end
        
        def before_each_scene
          @label[:effects].try(:push, @effects) || @label[:effects] = [ @effects ]
        end
        
        def default_attack
          @default_attack ||= EffectTransform.new.apply(EffectParser.new.root_processes.parse("敵単/SW物魔攻撃(1.0)"))
        end
        
        # @activeが所持している技を優先順位順にif elseで繋げる
        def create_tree
          temp = []
          tree = default_attack
          while effects = @active.effects.timing(:Effects).done_not.low_priority.try(:off)
            temp << effects
            tree = {
              :if => {
                :condition => effects.condition,
                :then => effects.do,
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
        
        def play_children
          catch @effects.keys.first do
            super
          end
        end
        
      end
    end
  end
end
