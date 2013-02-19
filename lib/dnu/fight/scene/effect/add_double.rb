# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class AddDouble < BaseEffect
        
        def play_children
          double_unique = @tree[:unique]
          
          # 重複不可でかつ既にこの特殊効果で対象のチームに分身を追加済みの場合はもう追加しない
          unless double_unique and @character.find_by_team(対象.team).double.find_by_parent(対象).find_by_parent_effect(@stack.last).present?
            @character.add_double(対象, @stack.last, true)
            success = true
          end
          
          history[:children] = { :success => success }
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
