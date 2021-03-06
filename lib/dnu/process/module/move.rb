module DNU
  module Process
    module Move
      
      def move
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          if user.register(:main).present?
            place = user.result(:place).first
            place.arrival = false
            place.save!
            user.register(:main).moves.where(:direction => [1,2,3,4]).each do |move|
              result_move = user.new_result(:move ,{
                :direction => move.direction,
                :from      => place.map_tip,
                :success   => true
              })
              
              result_place = user.new_result(:place, { :arrival => false })
              case move.direction
              when 1
                result_place.map_tip = place.map_tip.up
              when 2
                result_place.map_tip = place.map_tip.right
              when 3
                result_place.map_tip = place.map_tip.down
              when 4
                result_place.map_tip = place.map_tip.left
              end
              result_move.to = result_place.map_tip
              if result_place.map_tip.nil? or result_place.map_tip.collision
                result_move.success = false
                result_place.map_tip = place.map_tip
              end
              result_move.save!
              result_place.save!
              place = result_place
            end
            place.arrival = true
            place.save!
          end
        end
      end
      
    end
  end
end
