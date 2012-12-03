module DNU
  module Sanitizer
    def sanitize_before_validation(*cols)
      cols = cols.to_a.flatten.compact.map(&:to_sym)
      cols.each do |col|
        before_validation_col = "sanitize_before_validation_#{col}"
        
        class_eval do
          before_validation before_validation_col
        end
        
        class_eval %(
          private
          def #{before_validation_col}
            self.#{col} = DNU::Sanitize.code_to_code(self.#{col})
          end
        )
      end
    end
    
    def clean_before_validation(*cols)
      cols = cols.to_a.flatten.compact.map(&:to_sym)
      cols.each do |col|
        before_validation_col = "clean_before_validation_#{col}"
        
        class_eval do
          before_validation before_validation_col
        end
        
        class_eval %(
          private
          def #{before_validation_col}
            self.#{col} = ::Sanitize.clean(self.#{col})
          end
        )
      end
    end
  end
end
