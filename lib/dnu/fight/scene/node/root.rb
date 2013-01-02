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
          return scope if @tree[:passive][:target].nil?
          target1 = @parent.stack.last.respond_to?(:target) ? @parent.stack.last.target : nil
          target1 = (target1.nil? ? nil : scope.try(target1.keys.first, target1.values.first))
          target2 = [@tree[:passive][:target]].flatten
          scope.try(target2[0].to_s, target2[1] || @parent.passive.try(:call), @parent.active.try(:call), target1)
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
