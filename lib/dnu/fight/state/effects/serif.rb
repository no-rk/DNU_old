module DNU
  module Fight
    module State
      class Serif < BaseEffects
        def when_initialize(tree)
          @name = "セリフ"
        end
      end
    end
  end
end
