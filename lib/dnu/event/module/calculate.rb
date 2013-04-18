module DNU
  module Event
    module Calculate
      def fixnum(tree)
        tree.to_i
      end
      
      def variable(tree)
        name  = tree[:name].to_s
        
        result_event_variable = event_variables.where(:kind => :integer, :name => name).first
        result_event_variable.try(:value).to_i
      end
    end
  end
end
