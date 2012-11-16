class PlainInput < SimpleForm::Inputs::Base
  def input
    field_value = object[attribute_name].blank? ? I18n.t("blank", :scope => "form.message") : (collection ? collection.invert[object[attribute_name]] : object[attribute_name] )
    "#{field_value}#{@builder.hidden_field(attribute_name, input_html_options)}".html_safe
  end

  def collection
    @collection ||= options.delete(:collection)
  end
end
