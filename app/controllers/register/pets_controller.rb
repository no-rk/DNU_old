class Register::PetsController < Register::ApplicationController
  private
  def set_instance_variables
    @pet_id = params[:pet_id]
  end
  
  def register_index_records
    current_user.register_pets.where(:pet_id => @pet_id).page(params[:page]).per(Settings.register.history.per)
  end
  
  def register_new_record
    current_user.register_pets.where(:pet_id => @pet_id).first_or_initialize
  end
end
