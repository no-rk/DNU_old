class IdInput < SimpleForm::Inputs::Base
  enable :placeholder
  def input
    input_html_options[:placeholder] = "ENo."
    input_html_options[:'data-ajax-path'] = "ENo."
    "#{@builder.text_field(attribute_name, input_html_options)}".html_safe
  end
end
