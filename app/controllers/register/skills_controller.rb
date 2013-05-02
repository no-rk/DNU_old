class Register::SkillsController < Register::ApplicationController
  def index
    @skill_id = params[:skill_id]
    super
  end
  
  def new
    @skill_id = params[:skill_id]
    super
  end
  
  private
  def register_index_records
    current_user.register_skills.where(:skill_id => @skill_id).page(params[:page]).per(Settings.register.history.per)
  end
  
  def register_new_record
    current_user.register_skills.where(:skill_id => @skill_id).first_or_initialize
  end
end
