# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class NextScope < BaseScene
        include Calculate
        
        def play_children
          scope = @tree[:scope]
          
          対象.scope = scope
          
          history[:children] = { :scope => scope }
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
