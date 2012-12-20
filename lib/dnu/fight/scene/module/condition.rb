# encoding: UTF-8
module DNU
  module Fight
    module Scene
      module Condition
        include Damage
        
        def condition_damage(attack_type)
          p attack_type
          lambda do
            dmg = try('dmg_' + attack_type.to_s).call
            logger(attack_type => dmg)
            dmg
          end
        end
        
        def hit_physical
          lambda{ 自分. HIT.to_f/(自分. HIT.to_f + 対象. EVA.to_f) }
        end
        
        def hit_magical
          lambda{ 自分.MHIT.to_f/(自分.MHIT.to_f + 対象.MEVA.to_f) }
        end
        
        def hit_physical_magical
          lambda{ (hit_physical.call + hit_magical.call)/2.to_f }
        end
        
        def hit_element
          lambda{ 1.to_f }
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
        
        def state_character(tree)
          percent = (tree[:percent] || 100).to_f/100
          lambda{ r=try(tree[:state_target]).try(tree[:status_name])*percent; r }
        end
        
        def state_disease(tree)
          lambda{ try(tree[:state_target]).try(:disease,tree[:disease_name]) }
        end
        
        def just_before_attack(tree)
          hit_or_miss = tree.keys.first.to_s.camelize.to_sym
          lambda do
            begin
              history[:children].last[:Attack][:children].last[hit_or_miss].present?
            rescue
              false
            end
          end
        end
        
        def state_effect(tree)
          lambda{ r=rand; r }
        end
        
        def fixnum(val)
          lambda{ val.to_s.to_f }
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
