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
          scope = @character.try(@tree[:passive][:sub_scope].to_s, scope) unless @tree[:passive][:sub_scope].nil?
          @tree[:passive][:target].nil? ? scope : scope.try([@tree[:passive][:target]].flatten.first.to_s, [@tree[:passive][:target]].flatten.last)
        end
        
        def has_next_scene?
          ([@root_passive ||= create_passive].flatten - @root).present?
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
        
        def history
          @parent.history
        end
        
        def log_before_each_scene
          @history = (@parent.try(:history) || { :children => [] })[:children]
        end
        
      end
    end
  end
end
