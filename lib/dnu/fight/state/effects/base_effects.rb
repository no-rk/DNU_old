module DNU
  module Fight
    module State
      class BaseEffects < Array
        
        attr_reader :name
        
        def child_name(tree)
          tree.try(:keys).try(:first).try(:to_s).try(:camelize).try(:to_sym)
        end
        
        def when_initialize(tree)
        end
        
        def initialize(tree)
          @name = tree[:name].to_sym
          tree[:effects].each do |effect|
            push Effects.new(effect.merge(:parent => self))
          end
          when_initialize(tree)
        end
        
        def type
          self.class.name.split("::").last.to_sym
        end
        
      end
    end
  end
end
