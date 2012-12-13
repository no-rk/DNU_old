module DNU
  module Fight
    module Scene
      class Undefined < BaseScene
        
        def play_children
          p self.class.human_name
        end
        
      end
    end
  end
end
