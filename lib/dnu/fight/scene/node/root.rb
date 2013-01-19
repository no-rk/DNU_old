# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Root < BaseScene
        include FindTarget
        
        def before_all_scene
          @root = []
        end
        
        def root_passive
          if @root_passive.nil?
            play_(:before, :children)
            
            @root_passive = target(@tree[:target])
            
            play_(:after, :children)
          end
          @root_passive
        end
        
        def has_next_scene?
          (root_passive - @root).present?
        end
        
        def before_each_scene
          @root << (root_passive - @root).sample
          passive_now = @root.last
          passive_now = passive_now.respond_to?(:call) ? passive_now.call : passive_now
          @passive = lambda{ passive_now }
        end
        
        def create_children
          @children ||= create_from_hash(@passive.call.nil? ? { :empty => @tree[:target] } : @tree[:do])
        end
        
        def history
          @parent.history
        end
        
        def log_before_each_scene
          @history = @parent.try(:history) || {}
          @history = @history[:children] ||= []
        end
        
        def play
          self.each do |scene|
            play_children
          end
          @history.extend Html
        end
        
      end
    end
  end
end
