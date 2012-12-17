module DNU
  module Fight
    module Scene
      class If < BaseScene
        include Condition
        
        def when_initialize
          @if = { :then => nil, :else => nil }
          @if_condition = nil
          @then_or_else = nil
        end
        
        def create_condition
          @if_condition = condition(@tree[:condition])
        end
        
        def before_each_scene
          @then_or_else =  (@if_condition || create_condition).call ? :then : :else
          @children = @if[@then_or_else]
        end
        
        def create_children
          @tree[@then_or_else] ||= { :nothing => nil }
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
