# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class AddCharacter < BaseEffect
        
        def play_children
          character_kind        = @tree[:kind].keys.first
          character_setting     = @tree
          character_name        = character_setting[:name]
          character_definitions = @stack.last.respond_to?(:definitions) ? @stack.last.definitions : nil
          character_unique      = character_setting[:unique]
          
          # 重複不可でかつ既にこの特殊効果で対象のチームにキャラクターを追加済みの場合はもう追加しない
          unless character_unique and @character.find_by_team(対象.team).find_by_kind(character_kind).find_by_name(character_name).find_by_parent_effect(@stack.last).present?
            @character.add_character(character_kind, character_name, character_setting.merge(:team => 対象.team), character_definitions, 対象, @stack.last, true)
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
