class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def clone_record(record)
    nested_attr = record.nested_attributes_options.map{|key,value| key}
    return record.dup(:include=>nested_attr)
  end
  def changed?(record)
    last_record = eval "current_user.#{record.class.model_name.split('::').last.pluralize.downcase}.find(:last)"

    if last_record.nil?
      return false
    end

    nested_attr = record.nested_attributes_options.map{|key,value| key}
    return true if clone_record(record).to_json(:include=>nested_attr) != clone_record(last_record).to_json(:include=>nested_attr)
    false
  end
  def make_check
    if current_user.makes.count == 0
      redirect_to new_register_make_path, :alert => I18n.t("make_check", :scope => "register.message")
      return false
    end
  end
  def make_check!
    unless current_user.makes.count == 0
      redirect_to register_index_path
      return false
    end
  end
end
