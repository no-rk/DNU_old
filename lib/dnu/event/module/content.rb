module DNU
  module Event
    module Content
      def change_place(tree)
        result_place = user.result(:place).first
        result_place.arrival = false
        if result_place.save
          user.create_result!(:place, {
            :map_tip => GameData::MapTip.find_by_place(tree[:place]).first,
            :arrival => true
          })
        end
      end
      
      def set_flag(tree)
        kind  = tree.keys.first.to_s
        name  = tree.values.first[:name].to_s
        value = tree.values.first[:on].present?
        
        result_event_variable = event_variables.where(:kind => kind, :name => name).first_or_initialize
        result_event_variable.event = event
        result_event_variable.value = value
        result_event_variable.save!
      end
      
      def set_integer(tree)
        kind  = tree.keys.first.to_s
        name  = tree.values.first[:name].to_s
        value = tree.values.first[:integer].to_i
        plus  = tree.values.first[:plus].present?
        minus = tree.values.first[:minus].present?
        
        result_event_variable = event_variables.where(:kind => kind, :name => name).first_or_initialize
        result_event_variable.event = event
        if plus
          result_event_variable.value = result_event_variable.value.to_i + value
        elsif minus
          result_event_variable.value = result_event_variable.value.to_i - value
        else
          result_event_variable.value = value
        end
        result_event_variable.save!
      end
      
      def add_event(tree)
        kind = (tree[:kind] || "通常").to_s
        name = tree[:name].to_s
        
        user.add_event!({ kind => name }, day.day)
      end
      
      def add_item(tree)
        kind = tree[:kind].to_s
        name = tree[:name].to_s
        
        user.add_item!({ kind => name }, game_data_event, day.day)
      end
      
      def end_step(dummy)
        self.state = "終了"
        self.save!
      end
      
      def end_event(dummy)
        event.state = "終了"
        event.save!
      end
    end
  end
end
