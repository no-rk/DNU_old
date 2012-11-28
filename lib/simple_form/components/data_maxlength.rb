module SimpleForm
  module Components
    module DataMaxlength
      def data_maxlength
        input_html_options[:'data-maxlength'] ||= data_maximum_length_from_validation || limit
        nil
      end

      private

      def data_maximum_length_from_validation
        maxlength = options[:maxlength]
        if maxlength.is_a?(String) || maxlength.is_a?(Integer)
          maxlength
        else
          length_validator = find_length_validator

          if length_validator
            length_validator.options[:is] || length_validator.options[:maximum]
          end
        end
      end
    end
  end
end

if defined?(SimpleForm::Inputs::Base)
  SimpleForm::Inputs::Base.send :include, SimpleForm::Components::DataMaxlength
end
