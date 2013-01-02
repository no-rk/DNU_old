module DNU
  module Fight
    module Scene
      class Formation < BaseScene
        
        def play_children
          @active.call.team.each do |team|
            while @active.call.find_by_team(team).min{|a,b| a.Position <=> b.Position }.Position > 1
              @active.call.find_by_team(team).each{|c| c.Position.change_value(-1) }
              history[:children] = (history[:children] << team).uniq
            end
          end
        end
        
      end
    end
  end
end
