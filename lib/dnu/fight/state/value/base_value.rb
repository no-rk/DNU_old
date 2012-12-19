# encoding: UTF-8
module DNU
  module Fight
    module State
      class BaseValue < DelegateClass(Integer)
        attr_reader :initial, :equip_initial, :val, :equip_val
        
        def mix(val, equip_val)
          val + equip_val
        end
        
        def initialize(val, equip_val)
          @val       = @initial       = val
          @equip_val = @equip_initial = equip_val
          super mix(@val, @equip_val)
        end
        
        def set_val
          __setobj__ mix(@val, @equip_val)
        end
        
        def validate_value
        end
        
        def change_value(val)
          @val += val
          validate_value
          set_val
        end
        
        def validate_equip_value
        end
        
        def change_equip_value(equip_val)
          @equip_val += equip_val
          validate_equip_value
          set_val
        end
        
      end
    end
  end
end
