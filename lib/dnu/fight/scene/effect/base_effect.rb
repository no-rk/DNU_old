# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class BaseEffect < BaseScene
        
        def before_each_scene
          @passive = @passive.respond_to?(:call) ? @passive.call : @passive
        end
        
        def play_children
          p "#{@passive.name}に#{self.class.human_name}" unless @passive.nil?
        end
        
      end
    end
  end
end
