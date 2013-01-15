# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class AddCharacter < BaseScene
        include Calculate
        
        def play_children
          character_kind        = @tree[:kind].keys.first
          character_setting     = @tree
          character_name        = character_setting[:name]
          character_definitions = @stack.last.respond_to?(:definitions) ? @stack.last.definitions : nil
          
          # 重複不可でかつ既にキャラクター追加済みの場合はもう追加しない
          unless false
            @character.add_character(character_kind, character_name, character_setting.merge(:team => 対象.team), character_definitions, 対象, true)
            success = true
          end
          
          history[:children] = { :kind => character_kind, :name => character_name, :success => success }
        end
        
        def play_(b_or_a)
        end
        
      end
    end
  end
end
