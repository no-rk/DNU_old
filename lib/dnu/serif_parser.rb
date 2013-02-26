module DNU
  class SerifParser
        
    @@serif_parser = ExecJS.compile(
      File.read("#{Rails.root}/app/assets/javascripts/plugins/peg.function.js")+
      File.read("#{Rails.root}/app/assets/javascripts/plugins/peg.parser.js")
    )
    
    def self.parse(text)
      @@serif_parser.call('parser.parse', text, 'messages')
    end
  end
end
