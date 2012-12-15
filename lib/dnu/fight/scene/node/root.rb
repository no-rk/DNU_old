# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Root < BaseScene
        
        def when_initialize
          @root = []
        end
        
        def has_next_scene?
          scope = @character.try(@tree[:passive][:scope].to_s, @parent.active)
          @passive = scope.respond_to?(@tree[:passive][:target].to_s) ? scope.try(@tree[:passive][:target].to_s) : scope
          if @passive.respond_to?(:count)
            (@passive - @root).present?
          else
            super
          end
        end
        
        def before_each_scene
          scope = @character.try(@tree[:passive][:scope].to_s, @active)
          @passive = scope.respond_to?(@tree[:passive][:target].to_s) ? scope.try(@tree[:passive][:target].to_s) : scope
          if @passive.respond_to?(:count)
            @passive = (@passive - @root).sample
          end
        end
        
        def after_each_scene
          @root << @passive
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
