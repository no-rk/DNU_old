# encoding: UTF-8
module DNU
  module Fight
    module State
      class Effects
        
        attr_reader :type, :timing, :before_after, :condition, :do
        
        def child_name(tree)
          tree.try(:keys).try(:first).try(:to_s).try(:camelize).try(:to_sym)
        end
        
        def initialize(tree)
          @type         = child_name(tree[:timing][:effects])
          @timing       = child_name(tree[:timing])
          @before_after = child_name(tree[:before_after])
          @condition    = tree[:condition]
          @do           = tree[:do]
        end
        
      end
    end
  end
end
