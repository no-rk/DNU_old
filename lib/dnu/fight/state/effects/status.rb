# encoding: UTF-8
module DNU
  module Fight
    module State
      class Status < BaseEffects
        
        attr_reader :status_strength
        
        def when_initialize(tree)
          @status_strength = tree[:status_strength].to_i
        end
        
      end
    end
  end
end
