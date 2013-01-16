# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class NextElement < BaseScene
        include Calculate
        
        def play_children
          element = @tree[:element].to_hash
          
          対象.next_element = element
          
          history[:children] = { :element => element.keys.first }
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
