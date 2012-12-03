module DNU
  module Fight
    module Scene
      class Base
        attr_accessor :parent, :children, :character, :index, :break
        
        def self.human_name
          I18n.t(self.name.split("::")[3..4].join, :scope => "DNU.Fight.Scene")
        end
        
        def initialize(character)
          self.character = character
          children = self.initial_children
          children.each do |child|
            child.parent = self
          end
          self.children = children
        end
        
        def initial_children
          []
        end
        
        def has_next?
          self.children.blank? ? self.add_if_blank : true
        end
        
        def add_if_blank
          child = self.create_child
          return false if child.nil?
          child.parent = self
          self.children.push(child)
          true
        end
        
        def create_child
          nil
        end
        
        def next
          self.sort
          self.children.shift
        end
        
        def sort
        end
        
        def each
          index = {}
          while self.has_next?
            child  = self.next
            index[child.class] = 1 if index[child.class].nil?
            child.index = index[child.class]
            yield child
            break if child.break
            index[child.class] += 1
          end
        end
        
        def before
          p I18n.t("Before", :scope => "DNU.Fight.Scene", :Scene=>self.class.human_name)
        end
        
        def play
          p "#{self.class.human_name}#{self.index}"
          self.before
          self.play_children
          self.after
        end
        
        def play_children
          self.each do |child|
            child.play
          end
        end
        
        def after
          p I18n.t("After", :scope => "DNU.Fight.Scene", :Scene=>self.class.human_name)
        end
      end
    end
  end
end
