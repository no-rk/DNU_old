# encoding: UTF-8
module DNU
  module Fight
    module State
      class Characters < Array
        include Target
        
        def initialize(tree = {})
          if tree[:settings].present?
            tree[:settings].each do |pt|
              team = DNU::Fight::State::Team.new(pt[:pt_name].to_s, pt[:pt_caption].to_s)
              pt[:members].each do |character|
                character.merge!(:team => team)
                add_character(character, tree[:definitions])
              end
            end
          end
        end
        
        def add_character(setting, def_plus = [], parent=nil, parent_effect=nil, turn_end=nil)
          kind = setting[:kind].to_s
          name = setting[:name].to_s
          
          definition = def_plus.try(:find){|d| d[:kind]==kind and d[:name]==name }
          # 定義されていない場合はデータベースから読み込みを試みる
          if definition.blank?
            if setting[:eno].present?
              definition =        User.where(:id => setting[:eno].to_i).first.try(:tree, (setting[:correction] || Day.last_day_i).to_i, (setting[:battle_type] || GameData::BattleType.normal.name))
            elsif setting[:pno].present?
              definition = Result::Pet.where(:id => setting[:pno].to_i).first.try(:tree, (setting[:correction] || Day.last_day_i).to_i, (setting[:battle_type] || GameData::BattleType.normal.name))
            else
              object= GameData::Character.find_by_kind_and_name(kind, name)
              definition = object.try(:tree).try(:merge, {:object => object})
            end
            definition ||= {}
          end
          raise "[#{kind}]#{name}は定義されてない" if definition.blank?
          definition.merge!(setting).merge!({ :parent => parent, :parent_effect => parent_effect })
          character = DNU::Fight::State::Character.new(definition)
          character.turn_end = turn_end
          # 戦闘値決定時の特殊効果適用
          DNU::Fight::Scene::SetBattleValue.new([character].extend Target).play
          # この時点での戦闘値を元に最大値と最小値を決定する
          character.start
          self << character
          # ペット追加
          if definition[:pets].present?
            definition[:pets].each do |character_setting|
              add_character(character_setting.merge(:team => setting[:team]), [], character)
            end
          end
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
