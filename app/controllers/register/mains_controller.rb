class Register::MainsController < Register::ApplicationController
  private
  def set_instance_variables
    @direction_list ||= { :'休' => 0, :'上' => 1, :'右' => 2, :'下' => 3, :'左' => 4 }
    @selected_direction ||= @direction_list[:'休']
  end
end
