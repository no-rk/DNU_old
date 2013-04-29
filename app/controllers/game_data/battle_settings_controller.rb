class GameData::BattleSettingsController < GameData::ApplicationController
  def set_instance_variables
    @kinds = ["使用条件", "使用頻度", "対象指定"].inject({}){|h,s| h.tap{ h[s] = s} }
  end
end
