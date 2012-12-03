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
          [self.sample(*num)].flatten.extend Target
        end
        def method_missing(action, *args)
          p "target"
          p self
          p action
          p args
        end
      end
      class Character < Array
        include Target
        def initialize
          team = TEAM.new("A")
          3.times do
            child = PC.new
            child.team = team
            self << child
          end
          team = TEAM.new("B")
          3.times do
            child = PC.new
            child.team = team
            self << child
          end
        end
      end
    end
  end
end
