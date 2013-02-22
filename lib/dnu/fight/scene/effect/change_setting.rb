# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class ChangeSetting < BaseEffect
        
        def play_children
          change_setting_type  = @tree.keys.first.to_s.camelize.to_sym
          change_setting_name  = @tree.values.first[:name].try(:to_sym)
          change_setting_find  = @tree.values.first[:find].try(:keys).try(:first).try(:to_sym)
          change_setting_condition = @tree.values.first[:condition]
          
          change_setting_effects = 対象.effects.type(change_setting_type)
          # 名前が指定されてる場合は絞り込む
          change_setting_effects = change_setting_effects.find_by_name(change_setting_name) if change_setting_name.present?
          if change_setting_effects.present?
            case change_setting_find
            when :random
              change_setting_sample = change_setting_effects.sample
              change_setting_sample.condition = change_setting_condition
              effects_name = change_setting_sample.name
            when :all
              change_setting_effects.each do |e|
                e.condition = change_setting_condition
              end
            end
            success = true
          end
          
          history[:children] = {
            :name => effects_name,
            :change_setting_type => change_setting_type,
            :change_setting_name => change_setting_name,
            :change_setting_find => change_setting_find,
            :success             => success
          }
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
