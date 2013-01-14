module DNU
  module MapGsub
    
    def gsub(str, &block)
      bstr = to_binary(str)
      result = add_encoding("")
      prev_pos = 0
      scan_data = scan(str).uniq{|s|s[0]}
      scan_data.each do |key, pos, value|
        result << add_encoding(bstr[prev_pos...pos])
        result << yield(key, value)
        prev_pos = pos + bytesize(key)
      end
      result << add_encoding(bstr[prev_pos..-1])
      return result
    end
    
    def add_link(str, except=nil)
      gsub(str) do |key, value|
        if key.to_s == except.to_s
          key
        else
          value = value.split('/')
          key = %Q|<font color="##{value[2]}">#{key}</font>| if value[2].present?
          %Q|<a href="#{Rails.application.routes.url_helpers.ajax_help_url(value[0], value[1])}" data-remote="true" data-type="json" data-html="true" data-trigger="manual" rel="popover">#{key}</a>|
        end
      end.gsub(/(\n\r|\r\n|\n|\r)/,'<br>')
    end
    
  end
end
