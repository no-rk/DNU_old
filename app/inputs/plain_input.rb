class PlainInput < SimpleForm::Inputs::Base
  def input
    field_value = object.try(attribute_name).blank? ? I18n.t("blank", :scope => "form.message") : (collection ? collection.invert[object.try(attribute_name)] : object.try(attribute_name) )
    san = DNU::Sanitize.new(options[:user])
    "#{san.code_to_html(field_value)}#{@builder.hidden_field(attribute_name, input_html_options)}".html_safe
  end

  def collection
    @collection ||= options.delete(:collection)
  end
end
