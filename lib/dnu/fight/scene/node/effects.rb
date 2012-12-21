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
          @active.effects.timing(:Effects).sample.try(:do) || default_attack
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
