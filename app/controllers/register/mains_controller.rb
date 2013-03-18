class Register::MainsController < Register::ApplicationController
  private
  def set_instance_variables
    @direction_list ||= { :'休' => 0, :'上' => 1, :'右' => 2, :'下' => 3, :'左' => 4 }
    @selected_direction ||= @direction_list[:'休']
    @train_list ||= GameData::Train.includes(:trainable).find_all_by_visible(true).inject({}){ |h,r| h.tap{ h[r.name] = r.id } }
  end
end
