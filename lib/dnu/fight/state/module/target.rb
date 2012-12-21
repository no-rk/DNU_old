# encoding: UTF-8
module DNU
  module Fight
    module State
      module Target
        
        def live
          self.find_all{ |child| !child.dead }.extend Target
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
        
        def find_by_team(team)
          self.find_all{ |child| child.team == team }.extend Target
        end
        
        def find_by_team_not(team)
          self.find_all{ |child| child.team != team }.extend Target
        end
        
        def team
          self.uniq{ |child| child.team }.map{ |child| child.team }.extend Target
        end
        
        def random(*num)
          return self.sample if num.first.nil?
          self.sample(num.first).extend Target
        end
        
        def 自(active)
          active
        end
        
        def 味(active)
          find_by_team(active.team)
        end
        
        def 敵(active)
          find_by_team_not(active.team)
        end
        
        def 敵味(active)
          self
        end
        
        def 味敵(active)
          self
        end
        
        def 単(passive = nil)
          passive || random
        end
        
        def ラ(passive = nil)
          lambda{ random }
        end
        
        def 全(passive = nil)
          self
        end
        
        def 低(status_name)
          status_name = status_name[:status_name] || :HP
          lambda{ self.min{ |a,b| a.try(status_name)<=>b.try(status_name) } }
        end
        
        def 高(status_name)
          status_name = status_name[:status_name] || :HP
          lambda{ self.max{ |a,b| a.try(status_name)<=>b.try(status_name) } }
        end
        
        def 竜(master)
          self
        end
        
        def 人形(master)
          self
        end
        
      end
    end
  end
end
