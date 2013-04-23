module DNU
  module Event
    module Condition
      include Calculate
      include DNU::Fight::Scene::Condition
      
      def present_place(tree)
        map_name  = tree[:place][:name].to_s
        map_tip_x = tree[:place][:x].to_i
        map_tip_y = tree[:place][:y].to_i
        
        map_arel     = GameData::Map.arel_table
        map_tip_arel = GameData::MapTip.arel_table
        
        lambda{
          result_places.where(:arrival => true).
                        where(map_arel[:name].eq(map_name)).
                        where(map_tip_arel[:x].eq(map_tip_x)).
                        where(map_tip_arel[:y].eq(map_tip_y)).includes(:map).includes(:map_tip).exists?
        }
      end
      
      def get_flag(tree)
        lambda{
          flag = event_variables.where(:kind => "boolean", :name => tree[:name]).first.try(:value).present?
          if tree[:off].present?
            flag = !flag
          end
          flag
        }
      end
      
      def check_condition(tree)
        send(tree.keys.first, tree.values.first)
      end
    end
  end
end
