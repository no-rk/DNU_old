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
            logger.debug self.#{col}
            self.#{col} = DNU::Sanitize.code_to_code(self.#{col})
            logger.debug self.#{col}
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
            logger.debug self.#{col}
            self.#{col} = ::Sanitize.clean(self.#{col})
            logger.debug self.#{col}
          end
        )
      end
    end
  end

  class Sanitize
    @@elements = ['b','i','u','strike','s','ruby','rb','rt','img','br','font']
    @@attributes      = {'font'=>['size','color'],'img'=>['no']}
    @@attributes_html = {'font'=>['size','color'],'img'=>['no','src','class']}
    
    def initialize(user)
      @user  = user
      raise unless @user.class == User
    end

    def self.html_to_code(html)
      code = html.to_s.dup
      unless code.blank?
        doc = Nokogiri.HTML(code)
        doc.css('p,div').each do |br|
          br.swap Nokogiri::HTML::fragment('<br>' + br.inner_html)
        end
        code = doc.to_html
        code = ::Sanitize.clean(code,:elements=>@@elements,:attributes=>@@attributes)
        code.gsub!(/[\r\n]+/,"")
        code.gsub!(/<br.*?>/,"\n")
        code.sub!(/^\n/,"")
      end
      code
    end

    def self.code_to_code(code_val)
      code = code_val.to_s.dup
      unless code.blank?
        code.gsub!(/[\r\n]+/,'<br>')
        code = ::Sanitize.clean(code,:elements=>@@elements,:attributes=>@@attributes)
        code.gsub!(/[\r\n]+/,"")
        code.gsub!(/<br.*?>/,"\n")
      end
      code
    end

    def self.counter
      lambda{ |value| ::Sanitize.clean(value).gsub(/[\r\n]/,"").split(//) }
    end

    def code_to_html(code)
      html = code.to_s.dup
      unless html.blank?
        html.gsub!(/[\r\n]+/,'<br>')
        doc = Nokogiri.HTML(html)
        doc.css('img').each do |img|
          if img.attribute('no') && @user.icons && !@user.icons[img.attribute('no').value.to_i].nil?
            img.set_attribute('src',@user.icons[img.attribute('no').value.to_i])
            img.set_attribute('class','icon')
          else
            img.remove
          end
        end
        html = doc.to_html
        html = ::Sanitize.clean(html,:elements=>@@elements,:attributes=>@@attributes_html)
        html.gsub!(/[\r\n]+/,"")
      end
      html
    end
  end
end

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend DNU::Sanitizer
end
