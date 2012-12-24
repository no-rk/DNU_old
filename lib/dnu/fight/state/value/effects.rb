# encoding: UTF-8
module DNU
  module Fight
    module State
      class Effects
        
        attr_reader :type, :timing, :before_after, :priority, :condition, :do
        
        attr_accessor :done
        
        def child_name(tree)
          tree.try(:keys).try(:first).try(:to_s).try(:camelize).try(:to_sym)
        end
        
        def initialize(tree)
          @type         = child_name(tree[:type]) || :Skill
          @timing       = child_name(tree[:timing])
          @before_after = child_name(tree[:before_after])
          @priority     = tree[:priority].to_i
          @condition    = tree[:condition]
          @do           = tree[:do]
        end
        
        def on
          @done = nil
          self
        end
        
        def off
          @done = true
          self
        end
        
      end
    end
  end
end
