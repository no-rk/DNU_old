module DNU
  module Fight
    module State
      class Team
        attr_reader :name, :caption
        
        def initialize(name, caption = nil)
          @name    = name
          @caption = caption
        end
        
        def pretty_print(q)
          q.pp "[#{object_id}]#{name}"
        end
      end
    end
  end
end
