module DNU
  module Fight
    module State
      class BaseEffects < Array
        
        attr_reader :LV
        
        def child_name(tree)
          tree.try(:keys).try(:first).try(:to_s).try(:camelize).try(:to_sym)
        end
        
        def when_initialize(tree)
        end
        
        def initialize(tree)
          tree = Marshal.load(Marshal.dump(tree))
          when_initialize(tree)
          @name = tree[:name].to_sym
          @LV = tree[:lv]
          tree[:effects].each do |effect|
            push Effects.new(effect.merge(:parent => self))
          end
        end
        
        def type
          self.class.name.split("::").last.to_sym
        end
        
        def name
          @LV.nil? ? @name : "#{@name}LV#{@LV}"
        end
        
      end
    end
  end
end
