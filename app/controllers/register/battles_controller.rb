class Register::BattlesController < Register::ApplicationController
  private
  def set_instance_variables
    @learned_skills ||= current_user.result(:skill).inject({}){ |h,r| h.tap{ h["#{r.nickname} 消費#{r.cost}"] = r.skill.id } }
    @use_conditions ||= GameData::BattleSetting.select([:id,:name]).find_all_by_kind('使用条件').inject({}){ |h,r| h.tap{ h[r.name] = r.id } }
    @frequencies    ||= GameData::BattleSetting.select([:id,:name]).find_all_by_kind('使用頻度').inject({}){ |h,r| h.tap{ h[r.name] = r.id } }
    @targets        ||= GameData::BattleSetting.select([:id,:name]).find_all_by_kind('対象指定').inject({}){ |h,r| h.tap{ h[r.name] = r.id } }
    @selected_frequency     ||= GameData::BattleSetting.select(:id).find_by_name('頻度5').id
    @selected_use_condition ||= GameData::BattleSetting.select(:id).find_by_name('通常時').id
  end
end
