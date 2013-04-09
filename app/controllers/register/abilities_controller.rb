class Register::AbilitiesController < Register::ApplicationController
  # GET /register/abilities/:ability_id/new
  # GET /register/abilities/:ability_id/new.json
  def ability_id
    @ability_id = params[:ability_id].try(:to_i)
    new
  end
  
  private
  def set_instance_variables
    @abilities = Hash.new{ |hash,key| hash[key] = {} }
    current_user.result(:ability).where(:forget => false).includes(:ability).find_each do |ability|
      ability_id = ability.ability.id
      @abilities[ability_id][:nickname] = ability.nickname
      @abilities[ability_id][:lv]       = ability.lv
      @abilities[ability_id][:caption]  = ability.ability.caption
      
      ad_arel = GameData::AbilityDefinition.arel_table
      [:pull_down, :lv].each do |kind|
        @abilities[ability_id][:"#{kind}_effects"] = ability.ability_definitions.where(ad_arel[:kind].eq(kind)).where(ad_arel[:lv].lteq(ability.lv)).inject({}){ |h,r| h.tap{ h["LV#{r.lv}：#{r.caption}"] = r.id } }
      end
    end
  end
  def build_record(record)
    kinds = [:battle]
    @abilities.each do |ability_id, ability|
      # プルダウン効果
      if ability[:pull_down_effects].present?
        ids = ability[:pull_down_effects].map{ |k,v| v.to_i }
        kinds.each do |kind|
          unless record.ability_settings.exists?(:kind => kind, :ability_definition_id => ids)
            record.ability_settings.build(:kind => kind, :ability_definition_id => ids.min)
          end
        end
      end
      # LV効果
      ability[:lv_effects].each do |caption, id|
        kinds.each do |kind|
          unless record.ability_settings.exists?(:kind => kind, :ability_definition_id => id)
            record.ability_settings.build(:kind => kind, :ability_definition_id => id, :setting => true)
          end
        end
      end
    end
    record.ability_settings.sort_by!{ |r| r.ability_definition_id.to_i }
  end
end
