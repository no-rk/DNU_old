module DNU
  module Fight
    module Scene
      class Effect < BaseScene
        
        def after_each_scene
          @label[:each_effect].try(:each) do |h|
            if rand(100)<50
              p "+++++++++++++++++++++++++++"
              p "+ jump to #{h.keys.first} +"
              p "+++++++++++++++++++++++++++"
              throw h.keys.first
            end
          end
        end
        
        def before
        end
        
        def after
        end
        
      end
    end
  end
end
