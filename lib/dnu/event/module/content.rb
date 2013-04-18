module DNU
  module Event
    module Content
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
