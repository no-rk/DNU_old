# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class BaseEffect < BaseScene
        
        def before_each_scene
          # 各効果種の対象が変化するかもしれない
          if @active.call.next_target?
            next_target = @active.call.next_target
            @passive = lambda{ next_target }
          end
        end
        
      end
    end
  end
end
