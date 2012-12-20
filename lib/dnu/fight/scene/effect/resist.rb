# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Resist < BaseScene
        
        def play_children
          disease_name = @tree[:disease_name]
          history[:children] = { :disease_name => disease_name }
        end
        
        def before
        end
        
        def after
        end
        
      end
    end
  end
end
