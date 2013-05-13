module DNU
  class Text
    @@text_parser = ExecJS.compile(
      File.read("#{Rails.root}/app/assets/javascripts/plugins/text_parser.js")
    )
    @@text_transform = ExecJS.compile(
      CoffeeScript.compile(File.read("#{Rails.root}/app/assets/javascripts/plugins/textTransformer.js.coffee"))
    )
    
    def self.string(text)
      tree = self.parse(:string, text)["html"]
      self.transform(tree)
    end
    
    def self.message(text, from_user, to_user)
      tree = self.parse(:message, text)["html"]
      self.transform(tree, from_user.icons)
    end
    
    def self.document(text)
      tree = self.parse(:document, text)["html"]
      self.transform(tree)
    end
    
    def self.counter(type)
      lambda{ |text| self.parse(type, text)["count"] }
    end
    
    def self.parse(type, text)
      @@text_parser.call('parser.parse', text, type)
    end
    
    def self.preview(text)
      @@text_transform.call('textTransformer', text)
    end
    
    def self.map(array, icons)
      array.map{|h| self.transform(h, icons) }
    end
    
    def self.transform(tree, icons)
      case tree
      when String
        tree
      when Hash
        case tree["tag"]
        when 'string', 'message', 'element'
          self.map(tree["inner"], icons).join("")
        when 'column_2', 'column_3', 'align_left', 'align_right', 'align_center', 'align_justify'
          %Q|<div class='#{tree["tag"]}'>#{self.map(tree["inner"], icons).join("")}</div>|
        when 'serif'
          if tree["data"]["icon"]
            %Q|<div class='serif #{tree["data"]["position"]}'><img class='icon' src=#{icons[tree["data"]["icon"]]}><div class='balloon #{tree["data"]["balloon"]}'>#{self.map(tree["inner"], icons).join("")}</div></div>|
          else
            %Q|<div class='serif #{tree["data"]["position"]}'><div class='balloon #{tree["data"]["balloon"]}'>#{self.map(tree["inner"], icons).join("")}</div></div>|
          end
        when 'color'
          %Q|<font color='#{tree["data"]["color"]}'>#{self.map(tree["inner"], icons).join("")}</font>|
        when 'random'
          self.map(tree["inner"], icons).sample
        when 'sequence'
          self.map(tree["inner"], icons).first
        when 'dice'
          %Q|#{Array.new(tree["data"]["count"].to_i){ rand(tree["data"]["number"].to_i)+1 }.sum}(#{tree["data"]["count"]}d#{tree["data"]["number"]})|
        when 'br'
          "<br>"
        when 'ruby', 'rb'
          %Q|<span class="#{tree["tag"]}">#{self.map(tree["inner"], icons).join("")}</span>|
        when 'rt'
          %Q|<span class="rp">(</span><span class="#{tree["tag"]}">#{self.map(tree["inner"], icons).join("")}</span><span class="rp">)</span>|
        else
          %Q|<#{tree["tag"]}>#{self.map(tree["inner"], icons).join("")}</#{tree["tag"]}>|
        end
      end
    end
  end
end
