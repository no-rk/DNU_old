module DNU
  module Event
    module Content
      def set_flag(tree)
        kind  = tree.keys.first.to_s
        name  = tree.values.first[:name].to_s
        value = tree.values.first[:on].present?
        
        event_variables.where(:kind => kind, :name => name).first_or_create! do |event_variable|
          event_variable.event = event
          event_variable.value = value
        end
      end
      
      def set_integer(tree)
        kind  = tree.keys.first.to_s
        name  = tree.values.first[:name].to_s
        value = tree.values.first[:integer].to_i
        
        event_variables.where(:kind => kind, :name => name).first_or_create! do |event_variable|
          event_variable.event = event
          event_variable.value = value
        end
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
