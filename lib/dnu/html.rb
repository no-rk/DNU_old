module DNU
  module Html
    def dnu_string_html(*cols)
      cols.to_a.flatten.compact.map(&:to_sym).each do |col|
        class_eval %Q{
          def #{col}_html
            @#{col}_html ||= DNU::Text.new(character_active, character_passive).string(#{col}).html_safe
          end
          def #{col}_preview
            @#{col}_preview ||= DNU::Text.new(character_active, character_passive).string(#{col}, true).html_safe
          end
        }
      end
    end
    
    def dnu_message_html(*cols)
      cols.to_a.flatten.compact.map(&:to_sym).each do |col|
        class_eval %Q{
          def #{col}_html
            @#{col}_html ||= DNU::Text.new(character_active, character_passive).message(#{col}).html_safe
          end
          def #{col}_preview
            @#{col}_preview ||= DNU::Text.new(character_active, character_passive).message(#{col}, true).html_safe
          end
        }
      end
    end
    
    def dnu_document_html(*cols)
      cols.to_a.flatten.compact.map(&:to_sym).each do |col|
        class_eval %Q{
          def #{col}_html
            @#{col}_html ||= DNU::Text.new(character_active, character_passive).document(#{col}).html_safe
          end
          def #{col}_preview
            @#{col}_preview ||= DNU::Text.new(character_active, character_passive).document(#{col}, true).html_safe
          end
        }
      end
    end
  end
end

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend DNU::Html
end

if defined?(ActiveForm)
  ActiveForm.extend DNU::Html
end
