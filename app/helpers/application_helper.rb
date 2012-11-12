module ApplicationHelper
  def select_current
    return controller.controller_name if  controller.action_name == "index"
  end
  def active_current(url)
    if current_page?(url)
      return "active"
    end
  end
  def presence_tag(model,field)
    if presence?(model,field)
      return I18n.t("required_entry", :scope => "register.message")
    end
  end
  def presence?(model,field)
    model.class.validators.select { |e|
      e.is_a? ActiveModel::Validations::PresenceValidator
    }.map { |e| e.attributes }.flatten.include?(field)
  end
end
