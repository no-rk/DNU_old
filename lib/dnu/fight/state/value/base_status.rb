module DNU
  module Fight
    module State
      class BaseStatus < BaseValue
        attr_reader :status, :equip
        
        def mix(*val)
          val.sum
        end
        
        def ini
          mix(@status.ini, @equip.ini)
        end
        
        def val
          mix(@status.val, @equip.val)
        end
        
        def min
          mix(@status.min, @equip.min)
        end
        
        def max
          mix(@status.max, @equip.max)
        end
        
        def initialize(status_val, equip_val)
          @status = Status.new(status_val, self)
          @equip  =  Equip.new( equip_val, self)
          super val
        end
        
      end
    end
  end
end
