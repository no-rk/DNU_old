class Register::BattlesController < Register::ApplicationController
  private
  def set_instance_variables
    @battle_type_id = params[:battle_type_id]
  end
  
  def register_index_records
    current_user.register_battles.where(:battle_type_id => @battle_type_id).page(params[:page]).per(Settings.register.history.per)
  end
  
  def register_new_record
    current_user.register_battles.where(:battle_type_id => @battle_type_id).first_or_initialize
  end
end
