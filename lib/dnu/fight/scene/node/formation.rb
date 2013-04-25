module DNU
  module Fight
    module Scene
      class Formation < BaseScene
        
        def play_children
          @active.call.team.each do |team|
            while @active.call.find_by_team(team).min{|a,b| a.隊列 <=> b.隊列 }.隊列 > 1
              @active.call.find_by_team(team).each{|c| c.隊列.change_value(-1) }
              history[:children] = (history[:children] << team.name).uniq
            end
          end
        end
        
      end
    end
  end
end
