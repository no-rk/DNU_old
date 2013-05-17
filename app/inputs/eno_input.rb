class EnoInput < SimpleForm::Inputs::Base
  enable :placeholder
  def input
    user_name = User.where(:id => object.send(attribute_name)).first.try(:name, object.day.try(:day) || Day.last_day_i)
    if options[:read_only]
      "ENo.#{object.send(attribute_name)} #{user_name}#{@builder.hidden_field(attribute_name, input_html_options)}".html_safe
    else
      input_html_options[:placeholder] = "ENo."
      input_html_options[:'data-remote'] = true
      input_html_options[:'data-type'] = :json
      input_html_options[:'data-url'] = Rails.application.routes.url_helpers.ajax_user_path
      input_html_options[:'data-html'] = true
      input_html_options[:rel] = :tooltip
      input_html_options[:'title'] = "ENo.#{object.send(attribute_name)} #{user_name}" if User.where(:id => object.send(attribute_name)).present?
      "#{@builder.number_field(attribute_name, input_html_options)}".html_safe
    end
  end
end
