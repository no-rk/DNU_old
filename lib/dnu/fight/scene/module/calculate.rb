# encoding: UTF-8
module DNU
  module Fight
    module Scene
      module Calculate
        include Damage
        
        def fixnum(val)
          lambda{ val.to_s.to_f }
        end
        
        def lv(val)
          lambda{ @tree[:lv] || @stack.last.try(:LV).to_f }
        end
        
        # 現在の戦闘値
        def state_character(tree)
          status_or_equip = tree[:equip].nil? ? :status : :equip
          percent = (tree[:percent] || 100).to_f/100
          lambda{ r=try(tree[:state_target] || '対象').send(tree[:status_name]).send(status_or_equip)*percent; r }
        end
        
        # 1つ前の戦闘値
        def state_character_old(tree)
          status_or_equip = tree[:equip].nil? ? :status : :equip
          percent = (tree[:percent] || 100).to_f/100
          lambda{ r=try(tree[:state_target] || '対象').send(tree[:status_name]).send(status_or_equip).history[-2].try(:*, percent); r }
        end
        
        def state_disease(tree)
          lambda{ try(tree[:state_target] || '対象').try(child_name(tree[:disease_name])) }
        end
        
        # sceneによるstatus_nameの変化量合計
        def state_effects_sum_change(tree)
          scene       = tree.keys.first.to_s.camelize.to_sym
          status_name = tree.values.first.respond_to?(:values) ? tree.values.first.values.first : nil
          lambda do
            @stack.last.history.last.childrens_find_by_scene(scene).map do |children|
              status_name.to_s==children[:status_name].to_s ? (children[:after_change].to_i - children[:before_change].to_i).abs : 0
            end.sum.to_i
          end
        end
        
        # sceneによるstatus_nameの直前の変化量
        def state_effects_just_before_change(tree)
          scene       = tree.keys.first.to_s.camelize.to_sym
          status_name = tree.values.first.respond_to?(:values) ? tree.values.first.values.first : nil
          lambda do
            children = @stack.last.history.last.try(:childrens_find_by_scene, scene).try(:last) || @stack[-2].try(:history).try(:last).try(:childrens_find_by_scene, scene).try(:last)
            children ? (status_name.to_s==children[:status_name].to_s ? (children[:after_change].to_i - children[:before_change].to_i).abs : 0) : 0
          end
        end
        
        def random_number(tree)
          from = try(tree[:from].keys.first, tree[:from].values.first)
          to   = try(  tree[:to].keys.first,   tree[:to].values.first)
          lambda{ [from.call, to.call].min + rand((to.call-from.call).abs + 1) }
        end
        
        def add_coeff(tree)
          add_array = tree.map{ |h| try(h.keys.first, h.values.first) }
          lambda{ add_array.inject(0){|r,v| r=r+v.call } }
        end
        
        def multi_coeff(tree)
          multi_array = tree.map{ |h| try(h.keys.first, h.values.first) }
          lambda{ multi_array.inject(1){|r,v| r=r*v.call } }
        end
        
        def calcu_value(tree)
          logger(tree)
          lambda{ try(tree.keys.first, tree.values.first).call.to_f }
        end
        
      end
    end
  end
end
