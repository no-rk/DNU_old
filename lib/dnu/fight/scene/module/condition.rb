# encoding: UTF-8
module DNU
  module Fight
    module Scene
      module Condition
        include Calculate
        include HitRate
        
        def condition_damage(attack_type)
          lambda do
            dmg = try('dmg_' + attack_type.to_s).call
            logger(attack_type => dmg)
            dmg
          end
        end
        
        def hit?(tree)
          attack_type = tree.keys.first
          min_hit = (tree[attack_type][:min_hit] ||  50).to_f
          max_hit = (tree[attack_type][:max_hit] || 100).to_f
          lambda do
            hit_rate = min_hit + (max_hit - min_hit)*try('hit_' + attack_type.to_s).call*hit_element.call
            logger(:hit_rate => hit_rate)
            rand(100) < hit_rate
          end
        end
        
        def add?(tree)
          lambda{ r=rand; r<0.5 }
        end
        
        def random_percent(tree)
          lambda{ r=rand(100); r < tree.to_i }
        end
        
        def just_before_attack(tree)
          hit_or_miss = tree.keys.first.to_s.camelize.to_sym
          lambda do
            begin
              history[:children].select{ |h| h.keys.first == :Attack }.last[:Attack][:children].last[hit_or_miss].present?
            rescue
              false
            end
          end
        end
        
        def condition_not(tree)
          child = try(tree.keys.first, tree.values.first)
          lambda{ (child_call = child.call).nil? ? nil : !child_call }
        end
        
        def condition_ge(tree)
          left  = try(tree[:left ].keys.first, tree[:left ].values.first)
          right = try(tree[:right].keys.first, tree[:right].values.first)
          lambda{ (left_call = left.call) and (right_call = right.call) ? (left_call >= right_call) : nil }
        end
        
        def condition_eq(tree)
          left  = try(tree[:left ].keys.first, tree[:left ].values.first)
          right = try(tree[:right].keys.first, tree[:right].values.first)
          lambda{ (left_call = left.call) and (right_call = right.call) ? (left_call == right_call) : nil }
        end
        
        def condition_le(tree)
          left  = try(tree[:left ].keys.first, tree[:left ].values.first)
          right = try(tree[:right].keys.first, tree[:right].values.first)
          lambda{ (left_call = left.call) and (right_call = right.call) ? (left_call <= right_call) : nil }
        end
        
        def condition_and(tree)
          left  = try(tree[:left ].keys.first, tree[:left ].values.first)
          right = try(tree[:right].keys.first, tree[:right].values.first)
          lambda{ (left_call = left.call) and (right_call = right.call) ? (left_call and right_call) : nil }
        end
        
        def condition_or(tree)
          left  = try(tree[:left ].keys.first, tree[:left ].values.first)
          right = try(tree[:right].keys.first, tree[:right].values.first)
          lambda{ (left_call = left.call) and (right_call = right.call) ? (left_call or right_call) : nil }
        end
        
        def condition(tree)
          try(tree.keys.first,tree.values.first)
        end
        
      end
    end
  end
end