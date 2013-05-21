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
    
    def add_link(str, except=nil, remote = nil)
      str = DNU::Text.new.document(str)
      gsub(str){ |key, value|
        value = JSON.parse(value).first
        if key.to_s == except.to_s
          key
        else
          key_c = value['color'].present? ? %Q|<font color="##{value['color']}">#{key}</font>| : key
          if remote
            %Q|<a href="#{Rails.application.routes.url_helpers.help_path(key)}" data-remote="true" data-type="json" data-html="true" data-trigger="manual" rel="popover">#{key_c}</a>|
          else
            %Q|<a href="#{Rails.application.routes.url_helpers.help_path(key)}" target="_blank">#{key_c}</a>|
          end
        end
      }.html_safe
    end
    
  end
end

if defined?(Tx::Map)
  Tx::Map.send :include, DNU::MapGsub
end
