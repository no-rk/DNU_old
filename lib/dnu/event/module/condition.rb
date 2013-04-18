module DNU
  module Event
    module Condition
      include Calculate
      
      def present_place(tree)
        map_name  = tree[:place][:name].to_s
        map_tip_x = tree[:place][:x].to_i
        map_tip_y = tree[:place][:y].to_i
        
        map_arel     = GameData::Map.arel_table
        map_tip_arel = GameData::MapTip.arel_table
        
        result_places.where(:arrival => true).
                      where(map_arel[:name].eq(map_name)).
                      where(map_tip_arel[:x].eq(map_tip_x)).
                      where(map_tip_arel[:y].eq(map_tip_y)).includes(:map).includes(:map_tip).exists?
      end
      
      def get_flag(tree)
        flag = event_variables.where(:kind => "boolean", :name => tree[:name]).first.try(:value).present?
        if tree[:off].present?
          flag = !flag
        end
        flag
      end
      
      def condition_gt(tree)
        check_condition(tree[:left]) > check_condition(tree[:right])
      end
      
      def condition_lt(tree)
        check_condition(tree[:left]) < check_condition(tree[:right])
      end
      
      def condition_ge(tree)
        check_condition(tree[:left]) >= check_condition(tree[:right])
      end
      
      def condition_le(tree)
        check_condition(tree[:left]) <= check_condition(tree[:right])
      end
      
      def condition_and(tree)
        tree.all?{ |h| check_condition(h) }
      end
      
      def check_condition(tree)
        send(tree.keys.first, tree.values.first)
      end
    end
  end
end
