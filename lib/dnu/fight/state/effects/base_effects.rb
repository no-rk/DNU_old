module DNU
  module Fight
    module State
      class BaseEffects < Array
        
        attr_reader :LV, :history, :parent
        attr_accessor :interrupt
        
        def child_name(tree)
          tree.try(:keys).try(:first).try(:to_s).try(:camelize).try(:to_sym)
        end
        
        def when_initialize(tree)
        end
        
        def initialize(tree)
          @parent = tree[:parent]
          tree = Marshal.load(Marshal.dump(tree)) # parentはcloneしない
          @name = tree[:name].try(:to_sym) || "名称未定義"
          @LV = tree[:lv].nil? ? nil : DNU::Fight::State::LV.new(nil, tree[:lv])
          @history = []
          when_initialize(tree)
          tree[:effects].each do |effect|
            push Effects.new(effect.merge(:parent => self))
          end
        end
        
        def id
          object_id
        end
        
        def type
          self.class.name.split("::").last.to_sym
        end
        
        def name
          @LV.nil? ? @name : "#{@name}LV#{@LV.to_i}"
        end
      end
    end
  end
end
