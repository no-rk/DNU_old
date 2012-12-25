# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Resist < BaseScene
        
        def play_children
          disease_name = child_name(@tree[:disease_name])
          history[:children] = { :disease_name => disease_name }
        end
        
        def play_before
        end
        
        def play_after
        end
        
      end
    end
  end
end
