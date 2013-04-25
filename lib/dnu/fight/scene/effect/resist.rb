# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Resist < BaseEffect
        
        def play_children
          disease_name = @tree[:disease]
          history[:children] = { :status_name => disease_name }
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
