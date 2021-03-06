module DNU
  module Fight
    module State
      class BaseEffects < Array
        
        attr_reader :LV, :history, :parent, :kind
        attr_accessor :interrupt
        
        def child_name(tree)
          tree.try(:keys).try(:first).try(:to_s).try(:camelize).try(:to_sym)
        end
        
        def when_initialize(tree)
        end
        
        def initialize(tree)
          @parent = tree[:parent]
          tree = Marshal.load(Marshal.dump(tree)) # parentはcloneしない
          @kind = tree[:kind].try(:to_sym)
          @name = tree[:name].try(:to_sym) || "名称未定義"
          @LV = tree[:lv].nil? ? nil : DNU::Fight::State::BaseValue.new(nil, tree[:lv])
          @LV.start(1, 5) if @LV.present?
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
        
        def pretty_print(q)
          q.pp "[#{type}]#{name}"
        end
      end
    end
  end
end
