# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Resist < BaseScene
        
        def play_children
          p "#{@passive.name}は#{@tree[:disease_name]}に抵抗した！"
        end
        
        def before
        end
        
        def after
        end
        
      end
    end
  end
end
