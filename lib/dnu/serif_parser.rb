module DNU
  class SerifParser
    @@text_parser = ExecJS.compile(
      File.read("#{Rails.root}/app/assets/javascripts/plugins/text_parser.js")
    )
    
    def self.parse(type, text)
      @@text_parser.call('parser.parse', text, type)
    end
    
    def self.message(text)
      @@text_parser.call('parser.parse', text, 'message')
    end
    
    def self.document(text)
      @@text_parser.call('parser.parse', text, 'document')
    end
  end
end
