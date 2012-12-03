module DNU
  module Fight
    module Scene
      class PrePhase < Base
        def initial_children
          [Turn.new(self.character),Turn.new(self.character),Turn.new(self.character)]
        end
        def sort
        end
      end
    end
  end
end
