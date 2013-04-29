module DNU
  module Process
    module Shout
      
      def shout
        GameData::Map.find_each do |map|
          shouts = map.where_shouts_by_day_i
          map.arrival_map_tips_by_day_i.each do |map_tip|
            shouts.find_all{ |h| (h[:x]-map_tip.x)**2+(h[:y]-map_tip.y)**2<=h[:volume]**2 }.each do |h|
              result_shout = Result::Shout.new
              result_shout.day     = Day.last
              result_shout.map_tip = map_tip
              result_shout.shout   = h[:shout]
              result_shout.save!
            end
          end
        end
      end
      
    end
  end
end
