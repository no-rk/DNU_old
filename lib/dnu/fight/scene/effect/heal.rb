# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Heal < BaseScene
        
        def play_children
          history[:children] << "#{@tree[:status_name]}が回復した！"
        end
        
        def before
        end
        
        def after
        end
        
      end
    end
  end
end
