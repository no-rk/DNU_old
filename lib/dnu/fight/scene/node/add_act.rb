module DNU
  module Fight
    module Scene
      class AddAct < BaseScene
        
        # SPD‚È‚Ç‚É‰ž‚¶‚Ä’Ç‰Ás“®‚ª‚ ‚é‚©‚à‚µ‚ê‚È‚¢
        def has_next_scene?
          rand(100) < 50
        end
        
        def play_children
          history[:index] = @index + 1
          super
        end
        
      end
    end
  end
end
