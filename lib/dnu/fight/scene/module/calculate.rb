# encoding: UTF-8
module DNU
  module Fight
    module Scene
      module Calculate
        include Damage
        include FindTarget
        
        def condition_damage(attack_type)
          lambda do
            dmg = try('dmg_' + attack_type.to_s).call
            dmg
          end
        end
        
        def fixnum(val)
          lambda{ val.to_s.to_f }
        end
        
        def lv(val)
          lambda{ @tree[:lv] || @stack.last.try(:LV).to_f }
        end
        
        def equip_strength(val)
          lambda{ @tree[:equip_strength] || @stack.last.try(:equip_strength).to_f }
        end
        
        def state_target_group(tree)
          send(tree.keys.first, tree.values.first).map{ |c| c.respond_to?(:call) ? c.call : c }.extend DNU::Fight::State::Target
        end
        
        # 現在の戦闘値
        def state_character(tree)
          status_or_equip = tree[:equip].nil? ? :status : :equip
          percent = (tree[:percent] || 100).to_f/100
          ratio   = tree[:ratio] ? :ratio : :to_f
          if tree[:group]
            type = tree[:group_value].keys.first
            lambda do
              state_target_group(tree[:group]).send(type) do |c|
                r = c.send(tree[:status_name]).send(status_or_equip)
                r = r.send(ratio)*percent
                r
              end
            end
          else
            lambda do
              r = (tree[:group_target] || try(tree[:state_target] || '対象')).send(tree[:status_name]).send(status_or_equip)
              r = r.send(ratio)*percent
              r
            end
          end
        end
        
        # 1つ前の戦闘値
        def state_character_old(tree)
          status_or_equip = tree[:equip].nil? ? :status : :equip
          percent = (tree[:percent] || 100).to_f/100
          if tree[:group]
            type = tree[:group_value].keys.first
            lambda do
              state_target_group(tree[:group]).send(type) do |c|
                r = c.send(tree[:status_name]).send(status_or_equip)
                r = r.history[-2].try(:*, percent).try("/", ((tree[:ratio] and r.max!=0) ? r.max : 1).to_f)
                r
              end
            end
          else
            lambda do
              r = (tree[:group_target] || try(tree[:state_target] || '対象')).send(tree[:status_name]).send(status_or_equip)
              r = r.history[-2].try(:*, percent).try("/", ((tree[:ratio] and r.max!=0) ? r.max : 1).to_f)
              r
            end
          end
        end
        
        def state_disease(tree)
          if tree[:group]
            type = tree[:group_value].keys.first
            lambda do
              state_target_group(tree[:group]).send(type) do |c|
                r = c.try(child_name(tree[:disease_name]))
                r
              end
            end
          else
            lambda do
              r = (tree[:group_target] || try(tree[:state_target] || '対象')).try(child_name(tree[:disease_name]))
              r
            end
          end
        end
        
        def state_disease_old(tree)
          if tree[:group]
            type = tree[:group_value].keys.first
            lambda do
              state_target_group(tree[:group]).send(type) do |c|
                r = c.try(child_name(tree[:disease_name]))
                r
              end
            end
          else
            lambda do
              r = (tree[:group_target] || try(tree[:state_target] || '対象')).try(child_name(tree[:disease_name]))
              r = r.history[-2]
              r
            end
          end
        end
        
        def state_effects_count(tree)
          effects_type = tree.keys.first.to_s.camelize.to_sym
          effects_name = tree.values.first.values.first.to_s
          lambda{ 対象.effects.type(effects_type).find_by_name(effects_name).map{ |e| e.history.count }.sum.to_i }
        end
        
        # sceneによるstatus_or_disease_nameの変化量合計
        def state_effects_change(tree)
          type                   = tree[:type].keys.first
          scene                  = tree[:scene].keys.first.to_s.camelize.to_sym
          status_or_disease_name = tree[:scene].values.first.respond_to?(:values) ? tree[:scene].values.first.values.first : nil
          status_or_disease_name = status_or_disease_name.respond_to?(:keys) ? status_or_disease_name.keys.first : status_or_disease_name
          status_or_disease      = tree[:scene].values.first.respond_to?(:keys) ? tree[:scene].values.first.keys.first : nil
          lambda do
            @stack.last.history.last.childrens_find_by_scene(scene).map do |children|
              if status_or_disease_name
                status_or_disease_name.to_sym==children[:status_name].to_sym ? (children[:after_change].to_i - children[:before_change].to_i).abs : 0
              else
                (children[:after_change].to_i - children[:before_change].to_i).abs
              end
            end.select{ |i| i!=0 }.send(type).to_i
          end
        end
        
        # sceneによるstatus_or_disease_nameの直前の変化量
        def state_effects_just_before_change(tree)
          scene                  = tree.keys.first.to_s.camelize.to_sym
          status_or_disease_name = tree.values.first.respond_to?(:values) ? tree.values.first.values.first : nil
          status_or_disease_name = status_or_disease_name.respond_to?(:keys) ? status_or_disease_name.keys.first : status_or_disease_name
          status_or_disease      = tree.values.first.respond_to?(:keys) ? tree.values.first.keys.first : nil
          lambda do
            children = @stack.last.history.last.try(:childrens_find_by_scene, scene).try(:last) || @stack[-2].try(:history).try(:last).try(:childrens_find_by_scene, scene).try(:last)
            if children.present?
              if status_or_disease_name
                status_or_disease_name.to_sym==children[:status_name].to_sym ? (children[:after_change].to_i - children[:before_change].to_i).abs : 0
              else
                (children[:after_change].to_i - children[:before_change].to_i).abs
              end
            else
              0
            end
          end
        end
        
        # sceneによるstatus_or_disease_nameの直後の変化量
        def state_effects_just_after_change(tree)
          scene                  = tree.keys.first.to_s.camelize.to_sym
          status_or_disease_name = tree.values.first.respond_to?(:values) ? tree.values.first.values.first : nil
          status_or_disease_name = status_or_disease_name.respond_to?(:keys) ? status_or_disease_name.keys.first : status_or_disease_name
          status_or_disease      = tree.values.first.respond_to?(:keys) ? tree.values.first.keys.first : nil
          lambda do
            children = @stack.last.history.last.try(:childrens_find_by_scene, scene).try(:last) || @stack[-2].try(:history).try(:last).try(:childrens_find_by_scene, scene).try(:last)
            if children.present?
              if status_or_disease_name
                status_or_disease_name.to_sym==children[:status_name].to_sym ? children[:just_after].call.to_i : 0
              else
                children[:just_after].call.to_i
              end
            else
              0
            end
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
          lambda{ try(tree.keys.first, tree.values.first).call.to_f }
        end
        
      end
    end
  end
end
