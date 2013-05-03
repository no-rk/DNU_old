# encoding: UTF-8
module DNU
  module Fight
    module State
      module FindEffects
        
        def timing(name)
          self.find_all{ |child| child.timing.try(:to_sym) == name.to_sym }.extend FindEffects
        end
        
        def type(names)
          names = [names].flatten.map{|name| name.to_sym}
          self.find_all{ |child| names.include?(child.type.try(:to_sym)) }.extend FindEffects
        end
        
        def before
          self.find_all{ |child| child.before_after.try(:to_sym) == :Before }.extend FindEffects
        end
        
        def children
          self.find_all{ |child| child.before_after.nil? }.extend FindEffects
        end
        
        def after
          self.find_all{ |child| child.before_after.try(:to_sym) == :After }.extend FindEffects
        end
        
        def done_not
          self.find_all{ |child| !child.done }.extend FindEffects
        end
        
        def find_by_name(name)
          name.nil? ? self : (self.find_all{ |child| child.name.to_sym == name.to_sym }.extend FindEffects)
        end
        
        def find_by_id(id)
          self.find_all{ |child| child.id == id }.extend FindEffects
        end
        
        def find_by_parent(parent)
          self.find_all{ |child| child.parent.type == parent.type and child.parent.name == parent.name }.extend FindEffects
        end
        
        def pre_phasable
          self.find_all{ |child|  child.pre_phasable }.extend FindEffects
        end
        
        def phase
          self.find_all{ |child| !child.timing }.extend FindEffects
        end
        
        def leadoff
          self.find_all{ |child|  child.hostility }.extend FindEffects
        end
        
        def prepare
          self.find_all{ |child| !child.hostility }.extend FindEffects
        end
        
        def low_priority
          self.sort_by{rand}.max{ |a,b| a.priority <=> b.priority }
        end
        
        def high_priority
          self.sort_by{rand}.min{ |a,b| a.priority <=> b.priority }
        end
        
        def has_default_attack
          self.find_all{ |child| child.respond_to?(:default_attack) and child.default_attack.present? }.extend FindEffects
        end
      end
    end
  end
end
