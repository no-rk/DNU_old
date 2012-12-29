# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Disease < BaseScene
        
        def create_children
          @children ||= create_from_hash(@tree[:do])
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
