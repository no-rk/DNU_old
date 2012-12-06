module DNU
  module Fight
    module State
      class BaseValue
        attr_reader :value, :initial
        def initialize(val)
          @initial = val
          @value   = val
        end
        def change_to(val)
          @value = val
        end
      end
    end
  end
end
