# encoding: UTF-8
module DNU
  module Fight
    module Scene
      module Condition
        
        def 自分
          @active
        end
        
        def 対象
          @passive
        end
        
        def hit?(tree)
          lambda{ r=rand; r<0.5 }
        end
        
        
        def add?(tree)
          lambda{ r=rand; r<0.5 }
        end
        
        def random_percent(tree)
          lambda{ r=rand(100); r < tree.to_i }
        end
        
        def state_character_boolean(tree)
          lambda{ r=rand; r<0.5 }
        end
        
        def state_character(tree)
          percent = (tree[:percent] || 100).to_f/100
          lambda{ r=try(tree[:state_character_target]).try(tree[:status_name]).value*percent; r }
        end
        
        def state_effect_boolean(tree)
          lambda do
            begin
              history[:children].last[:Attack][:children].last[:Hit].present?
            rescue
              false
            end
          end
        end
        
        def state_effect(tree)
          lambda{ r=rand; r }
        end
        
        def fixnum(tree)
          lambda{ tree.to_s.to_f }
        end
        
        def condition_ge(tree)
          left  = try(tree[:left ].keys.first, tree[:left ].values.first)
          right = try(tree[:right].keys.first, tree[:right].values.first)
          lambda{ left.call >= right.call }
        end
        
        def condition_eq(tree)
          left  = try(tree[:left ].keys.first, tree[:left ].values.first)
          right = try(tree[:right].keys.first, tree[:right].values.first)
          lambda{ left.call == right.call }
        end
        
        def condition_le(tree)
          left  = try(tree[:left ].keys.first, tree[:left ].values.first)
          right = try(tree[:right].keys.first, tree[:right].values.first)
          lambda{ left.call <= right.call }
        end
        
        def condition_and(tree)
          left  = try(tree[:left ].keys.first, tree[:left ].values.first)
          right = try(tree[:right].keys.first, tree[:right].values.first)
          lambda{ left.call and right.call }
        end
        
        def condition_or(tree)
          left  = try(tree[:left ].keys.first, tree[:left ].values.first)
          right = try(tree[:right].keys.first, tree[:right].values.first)
          lambda{ left.call or right.call }
        end
        
        def condition(tree)
          try(tree.keys.first,tree.values.first)
        end
        
      end
    end
  end
end
