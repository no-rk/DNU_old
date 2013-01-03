module DNU
  module Fight
    module Scene
      class Result < BaseScene
        
        def play_children
          history[:children] = @active.call.team.map{|t| t.name}
        end
        
      end
    end
  end
end
