module DNU
  module Fight
    module Scene
      class AddAct < Base
        def initial_children
          [Physical.new(self.character)]
        end
      end
    end
  end
end
