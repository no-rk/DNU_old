# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class BaseEffect < BaseScene
        
        def before_each_scene
          # 各効果種の対象が変化するかもしれない
          if @active.call.next_target?
            next_target = @active.call.next_target
            @passive = lambda{ next_target }
          end
        end
        
        def just_after(nexts, val)
          lambda do
            r = val
            r = 自分.send("next_#{nexts}").call(r)     if 自分.send("next_#{nexts}?")
            r = 対象.send("next_#{nexts}_ant").call(r) if 対象.send("next_#{nexts}_ant?")
            r
          end
        end
        
        def next_change!(nexts, val)
            r = val
            r = 自分.send("next_#{nexts}!").call(r)     if 自分.send("next_#{nexts}?")
            r = 対象.send("next_#{nexts}_ant!").call(r) if 対象.send("next_#{nexts}_ant?")
            r
        end
        
      end
    end
  end
end
