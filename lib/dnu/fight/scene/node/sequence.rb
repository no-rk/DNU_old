module DNU
  module Fight
    module Scene
      class Sequence < BaseScene
        
        def initialize(character, tree = @@default_tree, parent = nil)
          super
          @sequence = []
        end
        
        def has_next_scene?
          @index < @tree.size
        end
        
        def next_scene
          @children = @sequence[@index]
        end
        
        def create_children
          @sequence[@index] = @children ||= create_from_hash(@tree[@index])
        end
        
        def before
        end
        
        def after
        end
        
      end
    end
  end
end
