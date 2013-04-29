class GameData::PointsController < GameData::ApplicationController
  def set_instance_variables
    @trains = ["Status", "Art", "Job", "Product", "Ability"].inject({}){|h,s| h.tap{ h["GameData::#{s}".constantize.model_name.human] = s} }
  end
end
