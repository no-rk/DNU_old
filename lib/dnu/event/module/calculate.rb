module DNU
  module Event
    module Calculate
      include DNU::Fight::Scene::Calculate
      
      def number_of_people(tree)
        case tree.keys.first
        when :party_members
          lambda{ user.result(:party, day.day).first.party_members.count }
        end
      end
      
      def variable(tree)
        name  = tree[:name].to_s
        
        lambda{
          result_event_variable = event_variables.where(:kind => :integer, :name => name).first
          result_event_variable.try(:value).to_i
        }
      end
    end
  end
end
