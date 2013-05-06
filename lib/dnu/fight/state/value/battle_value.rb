module DNU
  module Fight
    module State
      class BattleValue < SimpleDelegator
        attr_reader :object, :status, :equip
        
        def initialize(model)
          @object = model
          @status = BaseValue.new(self)
          @equip  = BaseValue.new(self) if object.has_equip_value
          if object.has_max
            status.start(object.min, status)
            equip.start(object.min, equip) if equip.present?
          end
          sync_value
        end
        
        def start
          if object.has_max
            status.max.start
            equip.max.start if equip.present?
          else
            status.start(object.min, object.max)
            equip.start(object.min, object.max) if equip.present?
          end
        end
        
        def change_value(n)
          status.change_value(n)
        end
        
        def change_to(n)
          status.change_to(n)
        end
        
        def max
          mix(status.max, equip.present? ? equip.max : 0)
        end
        
        def min
          mix(status.min, equip.present? ? equip.min : 0)
        end
        
        def val
          mix(status.val,  equip.present? ? equip.val  : 0)
        end
        
        def val!
          mix(status.val!, equip.present? ? equip.val! : 0)
        end
        
        private
        def mix(s, e)
          (s + e).to_i
        end
        
        def sync_value
          __setobj__ val
        end
      end
    end
  end
end
