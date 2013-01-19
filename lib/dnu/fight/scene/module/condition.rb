# encoding: UTF-8
module DNU
  module Fight
    module Scene
      module Condition
        include Calculate
        include HitRate
        include CriRate
        
        def hit?(tree)
          attack_type = @data.keys.first
          min_hit = (@data[attack_type][:min_hit] ||  50).to_f
          max_hit = (@data[attack_type][:max_hit] || 100).to_f
          lambda do
            hit_rate = min_hit + (max_hit - min_hit)*try('hit_' + attack_type.to_s).call*hit_element.call
            logger(:hit_rate_before => hit_rate)
            
            # 命中率決定前
            ["",attacks].flatten.each do |timing|
              play_(:before, :before, :"#{timing.to_s.underscore.camelize}Hitrate")
            end
            
            hit_rate = 自分.next_hitrate!.call(hit_rate)     if 自分.next_hitrate?
            hit_rate = 対象.next_hitrate_ant!.call(hit_rate) if 対象.next_hitrate_ant?
            logger(:hit_rate_after => hit_rate)
            
            # 命中率決定後
            ["",attacks].flatten.each do |timing|
              play_(:after, :after, :"#{timing.to_s.underscore.camelize}Hitrate")
            end
            
            rand(100) < hit_rate
          end
        end
        
        def critical?(tree)
          attack_type = @data.keys.first
          min_cri = (@data[attack_type][:min_cri] ||  10).to_f
          max_cri = (@data[attack_type][:max_cri] || 100).to_f
          lambda do
            cri_rate = min_cri + (max_cri - min_cri)*try('cri_' + attack_type.to_s).call*cri_element.call
            logger(:cri_rate => cri_rate)
            rand(100) < cri_rate
          end
        end
        
        def add?(tree)
          lambda{ r=rand; r<0.5 }
        end
        
        def next_not_change(tree)
          target =(tree[:state_target] || '対象').to_s
          nexts  = tree[:nexts].keys.first
          lambda{ !send(target).send("next_#{nexts}?") }
        end
        
        def random_percent(tree)
          val = try(tree.keys.first, tree.values.first)
          lambda{ r=rand(100); r < val.call }
        end
        
        def just_before(success)
          lambda do
            @stack.last.history.last.just_before_children_success[success].present?
          end
        end
        
        def condition_not(tree)
          child = try(tree.keys.first, tree.values.first)
          lambda{ (child_call = child.call).nil? ? nil : !child_call }
        end
        
        def condition_boolean(tree)
          try(tree[:do].keys.first, tree[:do].values.first)
        end
        
        def condition_ge(tree)
          if tree[:left]
            lefts = [try(tree[:left].keys.first, tree[:left].values.first)]
          else
            lefts = state_target_group(tree[:lefts][:group]).map{ |c| try(tree[:lefts][:do].keys.first, tree[:lefts][:do].values.first.merge(:group_target => c)) }
          end
          if tree[:right]
            rights = [try(tree[:right].keys.first, tree[:right].values.first)]
          else
            rights = state_target_group(tree[:rights][:group]).map{ |c| try(tree[:rights][:do].keys.first, tree[:rights][:do].values.first.merge(:group_target => c)) }
          end
          lambda do
            begin
              lefts.product(rights).any?{ |l,r| l.call >= r.call }
            rescue
              nil
            end
          end
        end
        
        def condition_eq(tree)
          if tree[:left]
            lefts = [try(tree[:left].keys.first, tree[:left].values.first)]
          else
            lefts = state_target_group(tree[:lefts][:group]).map{ |c| try(tree[:lefts][:do].keys.first, tree[:lefts][:do].values.first.merge(:group_target => c)) }
          end
          if tree[:right]
            rights = [try(tree[:right].keys.first, tree[:right].values.first)]
          else
            rights = state_target_group(tree[:rights][:group]).map{ |c| try(tree[:rights][:do].keys.first, tree[:rights][:do].values.first.merge(:group_target => c)) }
          end
          lambda do
            lefts.product(rights).any?{ |l,r| l.call == r.call }
          end
        end
        
        def condition_le(tree)
          if tree[:left]
            lefts = [try(tree[:left].keys.first, tree[:left].values.first)]
          else
            lefts = state_target_group(tree[:lefts][:group]).map{ |c| try(tree[:lefts][:do].keys.first, tree[:lefts][:do].values.first.merge(:group_target => c)) }
          end
          if tree[:right]
            rights = [try(tree[:right].keys.first, tree[:right].values.first)]
          else
            rights = state_target_group(tree[:rights][:group]).map{ |c| try(tree[:rights][:do].keys.first, tree[:rights][:do].values.first.merge(:group_target => c)) }
          end
          lambda do
            begin
              lefts.product(rights).any?{ |l,r| l.call <= r.call }
            rescue
              nil
            end
          end
        end
        
        def condition_and(tree)
          a = tree.map{ |h| send(h.keys.first, h.values.first) }
          lambda{ a.all?{ |la| la.call } }
        end
        
        def condition_or(tree)
          a = tree.map{ |h| send(h.keys.first, h.values.first) }
          lambda{ a.any?{ |la| la.call } }
        end
        
        def condition(tree)
          try(tree.keys.first, tree.values.first)
        end
        
      end
    end
  end
end
