module DNU
  module Fight
    module Scene
      class If < BaseScene
        
        def when_initialize
          @if = { :then => nil, :else => nil }
          @then_or_else = nil
        end
        
        def before_each_scene
          if rand(100)<50
            @then_or_else = :then
          else
            @then_or_else = :else
          end
          @children = @if[@then_or_else]
        end
        
        def create_children
          @tree[@then_or_else] ||= { :undefined => nil }
          @if[@then_or_else] = ( @children ||= create_from_hash(@tree[@then_or_else]) )
        end
        
        def before
        end
        
        def after
        end
        
      end
    end
  end
end
