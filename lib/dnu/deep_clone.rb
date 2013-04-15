module DNU
  module DeepClone
    def self.register(record)
      record_c = record.class.new.send(:initialize_dup, record)
      nested_attr = record.nested_attributes_options.map{ |key,value| key }
      nested_attr.each do |attr|
        if record_c.respond_to?("build_#{attr}")
          record.send("build_#{attr}") if record.send(attr).nil?
          r = record.send(attr)
          record_c.send("#{attr}=", self.register(r))
        else
          record.send(attr).each do |r|
            record_c.send(attr) << self.register(r)
          end
        end
      end
      record_c
    end
    
    def self.result(record)
      record.class.new.send(:initialize_dup, record)
    end
  end
end
