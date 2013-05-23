class GameData::SerifSettingsController < GameData::ApplicationController
  def set_instance_variables
    @kinds = ["発言条件"].inject({}){|h,s| h.tap{ h[s] = s} }
  end
end
