# encoding: UTF-8
module DNU
  module Fight
    module Scene
      module FindTarget
        
        # 集合要素
        
        def target_active(tree)
          [@active.call]
        end
        
        def target_passive(tree)
          [@passive.try(:call) || @active.call]
        end
        
        def target_my_team(tree)
          @character.find_by_team(@active.call.team)
        end
        
        def target_other_team(tree)
          @character.find_by_team_not(@active.call.team)
        end
        
        # 集合演算
        
        def target_union(tree)
          tree.inject([]){ |a,h| a = a | send(h.keys.first, h.values.first) }
        end
        
        def target_complement(tree)
          left  = send(tree[:left ].keys.first, tree[:left ].values.first)
          right = send(tree[:right].keys.first, tree[:right].values.first)
          left - right
        end
        
        def target_dependency(tree)
          master = send(tree[:master].keys.first, tree[:master].values.first)
          kind   = tree[:kind].keys.first.to_s.camelize.to_sym
          master.inject([]){ |a,c| a = a | @character.find_by_kind(kind).find_by_parent(c) }
        end
        
        # 集合検索
        
        def target_live_or_dead(tree)
          set = send(tree[:set].keys.first, tree[:set].values.first)
          live_or_dead = tree[:dead] ? "dead" : "live"
          set.find_all{ |child|  child.send(live_or_dead) }
        end
        
        def random(set)
          set.find_all{ |child| ((child.team == @active.call.team ? -1 : 1)*child.Position + @active.call.Position).abs <= @active.call.Range + 1 }.sample || set.sample
        end
        
        def target_find_random(tree, set)
          [lambda{ random(set) }]
        end
        
        def target_find_single(tree, set)
          [@passive.try(:call) || random(set)]
        end
        
        def target_find_state(tree, set)
          min_or_max = tree[:target_condition].keys.first
          status_or_disease_name = tree[:status_name] || tree[:disease_name].keys.first
          ratio = tree[:ratio] ? :ratio : :to_f
          [lambda{ set.send(min_or_max){ |a,b| a.send(status_or_disease_name).send(ratio) <=> b.send(status_or_disease_name).send(ratio) } }]
        end
        
        def target_find_all(tree, set)
          set
        end
        
        def target(tree)
          set = @active.call.next_target_set! || tree[:set]
          set = send(set.keys.first, set.values.first)
          send(tree[:find].keys.first, tree[:find].values.first, set)
        end
        
      end
    end
  end
end
