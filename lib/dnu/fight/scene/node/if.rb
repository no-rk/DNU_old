module DNU
  module Fight
    module Scene
      class If < BaseScene
        include Condition
        
        def attack_element
          @data.values.first[:element].keys.first.to_s.camelize
        end
        
        def attack_type
          child_name(@data).to_s.camelize
        end
        
        def attack_types
          child_name(@data).to_s.underscore.split("_").map{ |p_or_m| p_or_m.camelize }
        end
        
        def attack_element_and_types
          [attack_element].product(attack_types).map{ |a| a.join }
        end
        
        def attacks
          [attack_element, attack_types, attack_element_and_types].flatten
        end
        
        def when_initialize
          @if = { :then => nil, :else => nil }
          @if_condition = nil
          @then_or_else = nil
        end
        
        def create_condition
          @if_condition = condition(@tree[:condition])
        end
        
        def before_each_scene
          active_now  = @active.try(:call)
          passive_now = @passive.try(:call)
          @active  = lambda{ @tree[:active]  || active_now  }
          @passive = lambda{ @tree[:passive] || passive_now }
          @then_or_else =  (@if_condition || create_condition).call ? :then : :else
          @children = @if[@then_or_else]
        end
        
        def create_children
          @tree[@then_or_else] ||= { :nothing => nil }
          @if[@then_or_else] = ( @children ||= create_from_hash(@tree[@then_or_else]) )
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
