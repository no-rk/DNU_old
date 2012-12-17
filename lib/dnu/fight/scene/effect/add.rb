# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Add < BaseScene
        
        def play_children
          p "#{@passive.name}に#{@tree[:disease_name]}を追加した！"
        end
        
        def before
        end
        
        def after
        end
        
      end
    end
  end
end
