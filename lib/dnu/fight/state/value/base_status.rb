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
        
        def set_min_max
          @status.set_min_max
          @equip.set_min_max
          @validate = true
          validate_value
          @ini = val
        end
        
        def initialize(status_val, equip_val)
          @status = StatusValue.new(status_val, self)
          @equip  =  EquipValue.new( equip_val, self)
          @status_next = []
          @equip_next  = []
          super val
        end
        
        def next
          mix (status_next || @status.val), (equip_next || @equip.val)
        end
        
        def next!
          mix (status_next! || @status.val), (equip_next! || @equip.val)
        end
        
        def status_next
          @status_next.last
        end
        
        def status_next!
          @status_next.pop
        end
        
        def status_next=(val)
          @status_next = [val]
        end
        
        def equip_next
          @equip_next.last
        end
        
        def equip_next!
          @equip_next.pop
        end
        
        def equip_next=(val)
          @equip_next = [val]
        end
        
      end
    end
  end
end
