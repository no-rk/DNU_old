# encoding: UTF-8
module DNU
  module Fight
    module State
      module Target
        
        def avg_value
          size>=1 ? sum{ |c| yield(c) }.to_f/size.to_f : 0
        end
        
        def sum_value
          sum{ |c| yield(c) }
        end
        
        def min_value
          yield min{ |a,b| yield(a) <=> yield(b) }
        end
        
        def max_value
          yield max{ |a,b| yield(a) <=> yield(b) }
        end
        
        def live
          self.find_all{ |child|  child.live }.extend Target
        end
        
        def dead
          self.find_all{ |child|  child.dead }.extend Target
        end
        
        def turn_end
          self.find_all{ |child|  child.turn_end }.extend Target
        end
        
        def turn_end_not
          self.find_all{ |child| !child.turn_end }.extend Target
        end
        
        def double
          self.find_all{ |child|  child.double }.extend Target
        end
        
        def find_by_team(team)
          self.find_all{ |child| child.team == team }.extend Target
        end
        
        def find_by_team_not(team)
          self.find_all{ |child| child.team != team }.extend Target
        end
        
        def team
          self.uniq{ |child| child.team }.map{ |child| child.team }.extend Target
        end
        
        def find_by_kind(kind)
          self.find_all{ |child| child.kind.to_s==kind.to_s }.extend Target
        end
        
        def find_by_name(name)
          self.find_all{ |child| child.name.to_s==name.to_s }.extend Target
        end
        
        def find_by_position(position)
          self.find_all{ |child| child.Position==position }.extend Target
        end
        
        def find_by_parent(parent)
          self.find_all{ |child| child.parent==parent }.extend Target
        end
        
        def find_by_parent_effect(parent)
          self.find_all{ |child| child.parent_effect.type==parent.type and child.parent_effect.name==parent.name }.extend Target
        end
        
      end
    end
  end
end
