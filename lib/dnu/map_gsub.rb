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
    
  end
end
