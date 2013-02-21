module DNU
  module DeepClone
    def self.register(record)
      record_c = record.class.new.send(:initialize_dup, record)
      nested_attr = record.nested_attributes_options.map{ |key,value| key }
      nested_attr.each do |attr|
        if record_c.send(attr).nil?
          r = record.send(attr)
          record_c.send("#{attr}=", r.class.new.send(:initialize_dup, r))
        else
          record.send(attr).each do |r|
            record_c.send(attr) << r.class.new.send(:initialize_dup, r)
          end
        end
      end
      record_c
    end
  end
end
