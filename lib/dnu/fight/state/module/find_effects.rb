# encoding: UTF-8
module DNU
  module Fight
    module State
      module FindEffects
        
        def timing(name)
          self.find_all{ |child| child.timing.try(:to_sym) == name.to_sym }.extend FindEffects
        end
        
        def type(name)
          self.find_all{ |child| child.type.to_sym == name.to_sym }.extend FindEffects
        end
        
        def before
          self.find_all{ |child| child.before_after.to_sym == :Before }.extend FindEffects
        end
        
        def after
          self.find_all{ |child| child.before_after.to_sym == :After }.extend FindEffects
        end
        
        def done_not
          self.find_all{ |child| !child.done }.extend FindEffects
        end
        
        def find_by_name(name)
          name.nil? ? self : self.find_all{ |child| child.name.to_sym == name.to_sym }
        end
        
        def find_by_id(id)
          self.find_all{ |child| child.id == id }
        end
        
        def low_priority
          self.sort_by{rand}.max{ |a,b| a.priority <=> b.priority }
        end
        
      end
    end
  end
end
