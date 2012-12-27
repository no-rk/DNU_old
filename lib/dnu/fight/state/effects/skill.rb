module DNU
  module Fight
    module State
      class Skill < BaseEffects
        
        def when_initialize(tree)
          tree[:effects].each do |effect|
            effect[:priority]  = tree[:priority]
            effect[:condition] = tree[:condition]
            effect[:do] = {
              :sequence => [tree[:serif],effect[:do]]
            } if tree[:serif]
          end
        end
        
      end
    end
  end
end
