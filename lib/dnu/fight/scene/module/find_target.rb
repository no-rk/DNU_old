# encoding: UTF-8
module DNU
  module Fight
    module Scene
      module FindTarget
        
        # 集合要素
        
        def target_active(tree, l_or_d=[])
          [@active.call]
        end
        
        def target_passive(tree, l_or_d=[])
          [@passive.try(:call) || @active.call]
        end
        
        def target_my_team(tree, l_or_d=[])
          @character.find_by_team(@active.call.team)
        end
        
        def target_other_team(tree, l_or_d=[])
          @character.find_by_team_not(@active.call.team)
        end
        
        # 集合演算
        
        def target_union(tree, l_or_d=[])
          tree.inject([]){ |a,h| a = a | send(h.keys.first, h.values.first, l_or_d) }
        end
        
        def target_complement(tree, l_or_d=[])
          left  = send(tree[:left ].keys.first, tree[:left ].values.first, l_or_d)
          right = send(tree[:right].keys.first, tree[:right].values.first, l_or_d)
          left - right
        end
        
        def target_dependency(tree, l_or_d=[])
          master = send(tree[:master].keys.first, tree[:master].values.first, l_or_d)
          kind   = tree[:kind]
          master.inject([]){ |a,c| a = a | @character.find_by_kind(kind).find_by_parent(c) }
        end
        
        def target_live_or_dead(tree, l_or_d=[])
          set = send(tree[:set].keys.first, tree[:set].values.first, l_or_d)
          live_or_dead = tree[:dead] ? "dead" : "live"
          l_or_d << live_or_dead
          set.find_all{ |child|  child.send(live_or_dead) }
        end
        
        # 集合検索
        
        def random(set)
          set.find_all{ |child| ((child.team == @active.call.team ? -1 : 1)*child.隊列 + @active.call.隊列).abs <= @active.call.射程 + 1 }.sample || set.sample
        end
        
        def target_find_random(tree, set)
          [lambda{ random(set) }]
        end
        
        def target_find_single(tree, set)
          [@passive.try(:call) || random(set)]
        end
        
        def target_find_state(tree, set)
          min_or_max = tree[:target_condition].keys.first
          status_or_disease_name = tree[:battle_value] || tree[:disease]
          ratio = tree[:ratio] ? :ratio : :to_f
          [lambda{ set.send(min_or_max){ |a,b| a.send(status_or_disease_name).send(ratio) <=> b.send(status_or_disease_name).send(ratio) } }]
        end
        
        def target_find_all(tree, set)
          set
        end
        
        def target(tree)
          l_or_d = []
          set = @active.call.next_target_set! || tree[:set]
          set = send(set.keys.first, set.values.first, l_or_d)
          # 生存中や墓地中の表記が一度もなければ省略されたとし生存中として扱う
          set = set.find_all{ |child|  child.live } if l_or_d.blank?
          send(tree[:find].keys.first, tree[:find].values.first, set)
        end
        
      end
    end
  end
end
