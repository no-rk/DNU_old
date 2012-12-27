module DNU
  module Fight
    module State
      class Sup < BaseEffects
        
        attr_reader :LV
        
        def when_initialize(tree)
          @LV = tree[:lv]
        end
        
        def name
          @LV.nil? ? @name : "#{@name}LV#{@LV}"
        end
        
      end
    end
  end
end
