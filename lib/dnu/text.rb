module DNU
  class Text
    @@text_parser = ExecJS.compile(
      File.read("#{Rails.root}/app/assets/javascripts/plugins/text_parser.js")
    )
    @@text_transform = ExecJS.compile(
      CoffeeScript.compile(File.read("#{Rails.root}/app/assets/javascripts/plugins/textTransformer.js.coffee"))
    )
    
    def self.counter(type)
      lambda{ |text| self.new.parse(type, text)["count"] }
    end
    
    def initialize(character_active = nil, character_passive = nil)
      @character_active  = character_active
      @character_passive = character_passive
    end
    
    def parse(type, text)
      @@text_parser.call("parser.parse", text, type)
    end
    
    def preview(tree)
      @@text_transform.call("textTransformer", tree, (@character_active.try:icons || {}))
    end
    
    def string(text, pre = false)
      tree = parse(:string, text)["html"]
      pre ? preview(tree) : transform(tree)
    end
    
    def message(text, pre = false)
      tree = parse(:message, text)["html"]
      pre ? preview(tree) : transform(tree)
    end
    
    def document(text, pre = false)
      tree = parse(:document, text)["html"]
      pre ? preview(tree) : transform(tree)
    end
    
    def map(array)
      array.map{|h| transform(h) }
    end
    
    def list(array)
      array.inject("<li><span>"){ |s,h|
        if h["tag"]=="br"
          s << "</span></li><li><span>"
        else
          s << transform(h)
        end
      }  + "</span></li>"
    end
    
    def transform(tree)
      case tree
      when String
        tree
      when Hash
        case tree["tag"]
        when "string", "message", "document", "element"
          self.map(tree["inner"]).join("")
        when "column_2", "column_3", "align_left", "align_right", "align_center", "align_justify"
          if tree["data"]["color"].present?
            %Q|<div class="#{tree["tag"]}" style="background-color: #{tree["data"]["color"]}">#{self.map(tree["inner"]).join("")}</div>|
          else
            %Q|<div class="#{tree["tag"]}">#{self.map(tree["inner"]).join("")}</div>|
          end
        when "serif"
          if tree["data"]["icon"]
            icons = @character_active.try:icons || {}
            %Q|<div class="serif #{tree["data"]["position"]}"><img class="icon" src=#{icons[tree["data"]["icon"].to_i] || icons[1]}><div class="balloon #{tree["data"]["balloon"]}">#{self.map(tree["inner"]).join("")}</div></div>|
          else
            %Q|<div class="serif #{tree["data"]["position"]}"><div class="balloon #{tree["data"]["balloon"]}">#{self.map(tree["inner"]).join("")}</div></div>|
          end
        when "list"
          %Q|<pre class="prettyprint linenums"><ol class="linenums">#{self.list(tree["inner"])}</ol></pre>|
        when "color"
          %Q|<font color="#{tree["data"]["color"]}">#{self.map(tree["inner"]).join("")}</font>|
        when "random"
          self.map(tree["inner"]).sample
        when "sequence"
          self.map(tree["inner"]).first
        when "dice"
          %Q|#{Array.new(tree["data"]["count"].to_i){ rand(tree["data"]["number"].to_i)+1 }.sum}(#{tree["data"]["count"]}d#{tree["data"]["number"]})|
        when "br"
          "<br>"
        when "ruby", "rb"
          %Q|<span class="#{tree["tag"]}">#{self.map(tree["inner"]).join("")}</span>|
        when "rt"
          %Q|<span class="rp">(</span><span class="#{tree["tag"]}">#{self.map(tree["inner"]).join("")}</span><span class="rp">)</span>|
        else
          %Q|<#{tree["tag"]}>#{self.map(tree["inner"]).join("")}</#{tree["tag"]}>|
        end
      end
    end
  end
end
