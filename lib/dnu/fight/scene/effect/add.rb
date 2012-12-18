# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Add < BaseScene
        
        def play_children
          history[:children] << "#{@tree[:disease_name]}を追加された！"
        end
        
        def before
        end
        
        def after
        end
        
      end
    end
  end
end
