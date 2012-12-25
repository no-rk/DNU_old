# encoding: UTF-8
module DNU
  module Fight
    module State
      module FindEffects
        
        def timing(name)
          self.find_all{ |child| child.timing == name.to_sym }.extend FindEffects
        end
        
        def type(name)
          self.find_all{ |child| child.type == name.to_sym }.extend FindEffects
        end
        
        def before
          self.find_all{ |child| child.before_after == :Before }.extend FindEffects
        end
        
        def after
          self.find_all{ |child| child.before_after == :After }.extend FindEffects
        end
        
        def done_not
          self.find_all{ |child| !child.done }.extend FindEffects
        end
        
        def low_priority
          self.sort_by{rand}.max{ |a,b| a.priority <=> b.priority }
        end
        
      end
    end
  end
end