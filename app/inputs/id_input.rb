class IdInput < SimpleForm::Inputs::Base
  enable :placeholder
  def input
    input_html_options[:placeholder] = "ENo."
    input_html_options[:'data-remote'] = true
    input_html_options[:'data-type'] = :json
    input_html_options[:'data-url'] = Rails.application.routes.url_helpers.ajax_user_path
    "#{@builder.text_field(attribute_name, input_html_options)}<span></span>".html_safe
  end
end
