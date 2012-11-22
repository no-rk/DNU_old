class Register::ImagesController < Register::ApplicationController
  private
  def clone_record(record)
    record
  end
  def edit_action
    "new"
  end
  def save_success(register)
    register.upload_icons.each do |upload_icon|
      current_user.tag(upload_icon, :with => upload_icon.user_tag, :on => :tags)
    end
  end
end
