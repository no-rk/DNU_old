# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Heal < BaseScene
        
        def play_children
          history[:children] = "回復！"
        end
        
        def before
        end
        
        def after
        end
        
      end
    end
  end
end
