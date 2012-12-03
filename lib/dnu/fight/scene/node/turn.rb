module DNU
  module Fight
    module Scene
      class Turn < Base
        def initial_children
          [Act.new(self.character)]
        end
        def create_child
          AddAct.new(self.character) if rand(100) < 50
        end
      end
    end
  end
end
