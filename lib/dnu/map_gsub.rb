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
        %Q|<span data-help-path="#{Rails.application.routes.url_helpers.ajax_help_url(value[0])}" data-params="id=#{value[1]}">#{key}</span>|
      end
    end
    
  end
end
