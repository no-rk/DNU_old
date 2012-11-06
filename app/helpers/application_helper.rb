module ApplicationHelper
  def active_current(url)
    if current_page?(url)
      return "active"
    end
  end
  def presence_tag(model,field)
    if presence?(model,field)
      return Settings.message.required_entry
    end
  end
  def presence?(model,field)
    model.class.validators.select { |e|
      e.is_a? ActiveModel::Validations::PresenceValidator
    }.map { |e| e.attributes }.flatten.include?(field)
  end
end
