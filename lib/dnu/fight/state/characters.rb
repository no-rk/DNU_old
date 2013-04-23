# encoding: UTF-8
module DNU
  module Fight
    module State
      class Characters < Array
        include Target
        
        def initialize(tree)
          tree[:settings].each do |pt|
            team = DNU::Fight::State::Team.new(pt[:pt_name].to_s)
            pt[:members].each do |character|
              add_character(character.merge(:team => team), tree[:definitions])
            end
          end
        end
        
        def add_character(setting, definitions, parent=nil, parent_effect=nil, turn_end=nil)
          kind = setting[:kind].to_s
          name = setting[:name].to_s
          definition = definitions.try(:find){|d| d[:kind]==kind and d[:name]==name } || {}
          # 定義されていない場合はデータベースから読み込みを試みる
          if definition.blank?
            tree = GameData::Character.select(:definition).find_by_kind_and_name(kind, name)
            if tree.present?
              parser    = EffectParser.new
              transform = EffectTransform.new
              tree = parser.character_definition.parse(tree.definition)
              definition = transform.apply(tree)
            end
          end
          definition.merge!(setting).merge!({ :parent => parent, :parent_effect => parent_effect })
          character = DNU::Fight::State::Character.new(definition)
          character.turn_end = turn_end
          # 戦闘値決定時の特殊効果適用
          DNU::Fight::Scene::SetBattleValue.new([character].extend Target).play
          # この時点での戦闘値を元に最大値と最小値を決定する
          character.set_min_max
          self << character
        end
        
        def add_double(target, parent_effect=nil, turn_end=nil)
          character = target.build_double
          character.double        = true
          character.team          = target.team
          character.name          = "#{target.name}[分身]"
          character.parent        = target
          character.parent_effect = parent_effect
          character.turn_end      = turn_end
          self << character
        end
        
      end
    end
  end
end
