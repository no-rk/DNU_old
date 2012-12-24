# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Disease < BaseScene
        
        def create_children
          @children ||= create_from_hash(@tree[:do])
        end
        
        def play_before
        end
        
        def play_after
        end
        
      end
    end
  end
end
