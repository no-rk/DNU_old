# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Reduce < BaseScene
        
        def play_children
          history[:children] << "#{@tree[:disease_name]}を軽減した！"
        end
        
        def before
        end
        
        def after
        end
        
      end
    end
  end
end
