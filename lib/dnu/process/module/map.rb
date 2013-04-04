module DNU
  module Process
    module Map
      
      def map
        GameData::Map.find_each do |map|
          result_map = Result::Map.where(:day_id => Day.last.id, :map_id => map.id).first_or_initialize
          result_map.day = Day.last
          result_map.map = map
          result_map.image = DNU::GenerateMap.apply(map)
          result_map.save!
        end
      end
      
    end
  end
end
