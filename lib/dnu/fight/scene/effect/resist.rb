# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Resist < BaseScene
        
        def play_children
          history[:children] << "#{@tree[:disease_name]}に抵抗した！"
        end
        
        def before
        end
        
        def after
        end
        
      end
    end
  end
end
