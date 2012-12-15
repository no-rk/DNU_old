# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class If < BaseScene
        
        def when_initialize
          @if = { :then => nil, :else => nil }
          @if_condition = nil
          @then_or_else = nil
        end
        
        def 自分
          @active
        end
        
        def 対象
          @passive
        end
        
        def state_character_boolean(tree)
          p "con chara b"
          p "<pre>" + tree.to_yaml + "</pre>"
          lambda{ p r=rand; r<0.5 }
        end
        
        def state_character(tree)
          p "con chara"
          p "<pre>" + tree.to_yaml + "</pre>"
          lambda{ p r=rand; r }
        end
        
        def state_effect_boolean(tree)
          p "con effe b"
          p "<pre>" + tree.to_yaml + "</pre>"
          lambda{ p r=rand; r<0.5 }
        end
        
        def state_effect(tree)
          p "con effe"
          p "<pre>" + tree.to_yaml + "</pre>"
          lambda{ p r=rand; r }
        end
        
        def fixnum(tree)
          p "fixnum"
          p tree
          lambda{ tree.to_s.to_f }
        end
        
        def condition_ge(tree)
          p "con ge"
          p "<pre>" + tree.to_yaml  + "</pre>"
          left  = try(tree[:left ].keys.first, tree[:left ].values.first)
          right = try(tree[:right].keys.first, tree[:right].values.first)
          lambda{ left.call >= right.call }
        end
        
        def condition_eq(tree)
          p "con eq"
          p "<pre>" + tree.to_yaml  + "</pre>"
          left  = try(tree[:left ].keys.first, tree[:left ].values.first)
          right = try(tree[:right].keys.first, tree[:right].values.first)
          lambda{ left.call == right.call }
        end
        
        def condition_le(tree)
          p "con le"
          p "<pre>" + tree.to_yaml  + "</pre>"
          left  = try(tree[:left ].keys.first, tree[:left ].values.first)
          right = try(tree[:right].keys.first, tree[:right].values.first)
          lambda{ left.call <= right.call }
        end
        
        def condition_and(tree)
          p "con and"
          p "<pre>" + tree.to_yaml  + "</pre>"
          left  = try(tree[:left ].keys.first, tree[:left ].values.first)
          right = try(tree[:right].keys.first, tree[:right].values.first)
          lambda{ left.call and right.call }
        end
        
        def condition_or(tree)
          p "con or"
          p "<pre>" + tree.to_yaml  + "</pre>"
          left  = try(tree[:left ].keys.first, tree[:left ].values.first)
          right = try(tree[:right].keys.first, tree[:right].values.first)
          lambda{ left.call or right.call }
        end
        
        def condition(tree)
          p "con"
          p "<pre>" + tree.to_yaml + "</pre>"
          try(tree.keys.first,tree.values.first)
        end
        
        def create_condition
          p "cre con"
          @if_condition = condition(@tree[:condition])
        end
        
        def before_each_scene
          @then_or_else =  (@if_condition || create_condition).call ? :then : :else
          @children = @if[@then_or_else]
        end
        
        def create_children
          @tree[@then_or_else] ||= { :undefined => nil }
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
