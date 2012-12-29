# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class Interrupt < BaseScene
        
        def play_children
          interrupt_type = @tree.keys.first.to_s.camelize.to_sym
          effects_type   = @stack[-2].try(:type)
          effects_name   = @stack[-2].try(:name)
          
          @stack[-2].interrupt = lambda{ true } if effects_type == interrupt_type
          
          history[:children] = { :type => effects_type, :name => effects_name, :interrupt => interrupt_type }
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
