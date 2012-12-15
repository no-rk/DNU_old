module DNU
  module Fight
    module Scene
      class Root < BaseScene
        
        def when_initialize
          @root = []
          @root_passive = nil
        end
        
        def create_passive
          scope = @character.try(@tree[:passive][:scope].to_s, @parent.active)
          @root_passive = scope.respond_to?(@tree[:passive][:target].to_s) ? scope.try(@tree[:passive][:target].to_s) : scope
        end
        
        def has_next_scene?
          ([@root_passive || create_passive].flatten - @root).present?
        end
        
        def before_each_scene
          @root << ([@root_passive].flatten - @root).sample
          @passive = @root.last
          @passive = @passive.respond_to?(:call) ? @passive.call : @passive
        end
        
        def after_all_scene
          @root = []
        end
        
        def create_children
          @children ||= create_from_hash(@tree[:do])
        end
        
        def before
        end
        
        def after
        end
        
      end
    end
  end
end
