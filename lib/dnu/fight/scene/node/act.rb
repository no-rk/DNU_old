module DNU
  module Fight
    module Scene
      class Act < Base
        def initial_children
          [Physical.new(self.character)]
        end
      end
    end
  end
end
