class PlainInput < SimpleForm::Inputs::Base
  def input
    field_value = object.send(attribute_name).nil? ? I18n.t("blank", :scope => "form.message") : (collection ? collection.invert[object.send(attribute_name)] : object.send(attribute_name) )
    "#{field_value}#{@builder.hidden_field(attribute_name, input_html_options)}".html_safe
  end

  def collection
    @collection ||= options.delete(:collection)
  end
end
