# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Down < BaseScene
        
        def play_children
          history[:children] << "#{@tree[:status_name]}が低下した！"
        end
        
        def before
        end
        
        def after
        end
        
      end
    end
  end
end
