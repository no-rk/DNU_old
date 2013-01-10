module DNU
  module MapGsub
    
    def gsub(str, &block)
      bstr = to_binary(str)
      result = add_encoding("")
      prev_pos = 0
      scan(str) do |key, pos, value|
        result << add_encoding(bstr[prev_pos...pos])
        result << yield(key, value)
        prev_pos = pos + bytesize(key)
      end
      result << add_encoding(bstr[prev_pos..-1])
      return result
    end
    
    def add_link(str)
      gsub(str) do |key, value|
        value = value.split('/')
        key = %Q|<font color="##{value[2]}">#{key}</font>| if value[2].present?
        %Q|<a href="#{Rails.application.routes.url_helpers.ajax_help_url(value[0], value[1])}" data-remote="true" data-type="json" data-html="true" data-trigger="manual" rel="popover">#{key}</a>|
      end
    end
    
  end
end
