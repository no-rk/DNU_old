class Register::AbilitiesController < Register::ApplicationController
  def ability_id
    @ability_id = params[:ability_id].try(:to_i)
    new
  end
  
  private
  def set_instance_variables
    @abilities = Hash.new { |hash,key| hash[key] = {} }
    parser    = EffectParser.new
    transform = EffectTransform.new
    current_user.result(:ability).where(:forget => false).includes(:ability).find_each do |ability|
      @abilities[ability.ability_id][:nickname] = ability.nickname
      @abilities[ability.ability_id][:lv] = ability.lv
      @abilities[ability.ability_id][:caption] = ability.ability.caption
      
      tree = parser.ability_definition.parse(ability.ability.definition)
      tree = transform.apply(tree)
      @abilities[ability.ability_id][:lv_effects] = []
      @abilities[ability.ability_id][:pull_down_effects] = []
      tree[:definitions].each do |effect|
        if ability.lv.to_i >= effect[:lv].to_i
          if effect[:pull_down].present?
            @abilities[ability.ability_id][:pull_down_effects].push(effect)
          else
            @abilities[ability.ability_id][:lv_effects].push(effect)
          end
        end
      end
      
    end
  end
end
