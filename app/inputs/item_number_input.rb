class ItemNumberInput < SimpleForm::Inputs::Base
  enable :placeholder
  def input
    if options[:read_only]
      item_name = User.where(:id => options[:eno]).first.try(:result, :inventory, object.day.try(:day) || Day.last_day_i).try(:where, :number => object.send(attribute_name)).try(:first).try(:name)
      "ItemNo.#{object.send(attribute_name)} #{item_name}#{@builder.hidden_field(attribute_name, input_html_options)}".html_safe
    else
      input_html_options[:placeholder] = "ItemNo."
      "#{@builder.number_field(attribute_name, input_html_options)}".html_safe
    end
  end
end
