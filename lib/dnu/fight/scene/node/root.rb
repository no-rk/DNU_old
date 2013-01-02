module DNU
  module Fight
    module Scene
      class Root < BaseScene
        
        def when_initialize
          @root = []
          @root_passive = nil
        end
        
        def create_passive
          scope = @character.live.try(@tree[:passive][:scope].to_s, @parent.active.try(:call))
          scope = @character.try(@tree[:passive][:sub_scope].to_s, scope) unless @tree[:passive][:sub_scope].nil?
          target = [@tree[:passive][:target]].flatten
          @tree[:passive][:target].nil? ? scope : scope.try(target[0].to_s, target[1] || [@parent.passive.try(:call), @parent.stack.last.respond_to?(:target) ? @parent.stack.last.target : nil])
        end
        
        def has_next_scene?
          ([@root_passive ||= create_passive].flatten - @root).present?
        end
        
        def before_all_scene
          @root = []
        end
        
        def before_each_scene
          @root << ([@root_passive].flatten - @root).sample
          passive_now = @root.last
          passive_now = passive_now.respond_to?(:call) ? passive_now.call : passive_now
          @passive = lambda{ passive_now }
        end
        
        def create_children
          @children ||= create_from_hash(@tree[:do])
        end
        
        def play_(b_or_a)
        end
        
        def history
          @parent.history
        end
        
        def log_before_each_scene
          @history = @parent.try(:history) || {}
          @history = @history[:children] ||= []
        end
        
      end
    end
  end
end
