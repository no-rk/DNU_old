# encoding: UTF-8
module DNU
  module Fight
    module State
      class DefaultAttack < BaseEffects
        
        def when_initialize(tree)
          @name = :"通常攻撃"
        end
        
      end
    end
  end
end
