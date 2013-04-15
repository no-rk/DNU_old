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
    current_user.result(:ability).where(:forget => false).includes(:ability).includes(:ability_name).find_each do |ability|
      ab_id = ability.ability.id
      @abilities[ab_id][:nickname] = ability.nickname
      @abilities[ab_id][:lv]       = ability.lv
      @abilities[ab_id][:caption]  = ability.ability.caption
      
      ad_arel = GameData::AbilityDefinition.arel_table
      [:pull_down, :lv].each do |kind|
        @abilities[ab_id][:"#{kind}_effects"] = ability.ability_definitions.where(ad_arel[:kind].eq(kind)).where(ad_arel[:lv].lteq(ability.lv)).inject({}){ |h,r| h.tap{ h["LV#{r.lv}：#{r.caption}"] = r.id } }
      end
    end
  end
  def build_record(record)
    kinds = [:battle]
    
    @abilities.each do |ab_id, ability|
      kinds.each do |kind|
        first_or_build = { :kind => kind, :game_data_ability_id => ab_id }
        if record.ability_confs.exists?(first_or_build)
          ability_conf = record.ability_confs.where(first_or_build).first
        else
          ability_conf = record.ability_confs.build(first_or_build)
        end
        ability_conf.build_ability_name if ability_conf.ability_name.nil?
        # プルダウン効果
        if ability[:pull_down_effects].present?
          ids = ability[:pull_down_effects].map{ |k,v| v.to_i }
          unless ability_conf.ability_settings.exists?(:ability_definition_id => ids)
            ability_conf.ability_settings.build(:ability_definition_id => ids.min)
          end
        end
        # LV効果
        ability[:lv_effects].each do |caption, id|
          unless ability_conf.ability_settings.exists?(:ability_definition_id => id)
            ability_conf.ability_settings.build(:ability_definition_id => id, :setting => true)
          end
        end
        ability_conf.ability_settings.sort_by!{ |r| r.ability_definition_id.to_i }
      end
    end
    record.ability_confs.sort_by!{ |r| r.game_data_ability_id.to_i }
  end
end
