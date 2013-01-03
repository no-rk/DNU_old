# encoding: UTF-8
module DNU
  module Fight
    module State
      class Character < Array
        include Target
        
        def initialize(tree)
          tree[:settings].each do |pt|
            team = DNU::Fight::State::Team.new(pt[:pt_name])
            pt[:members].each do |character|
              definition = tree[:definitions].try(:find){|d| d[:type]==character[:type] and d[:name]==character[:name] } || {}
              definition.merge!(character).merge!(:team => team)
              self << "DNU::Fight::State::#{character[:type].keys.first}".constantize.new(definition)
            end
          end
        end
        
      end
    end
  end
end
