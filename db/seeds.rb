# encoding: UTF-8

# 日付
if Day.last.nil?
  Day.create!(:day => 0, :state => 2)
end

# ジョブ, 守護, 言葉, 戦闘値, 生産, 属性, 戦闘設定, ポイント
[:job, :guardian, :word, :battle_value, :product, :element, :battle_setting, :point].each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_#{table.to_s.tableize}")
  list = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/#{table}.yml")).result)
  list.each do |data|
    #p data
    model = "GameData::#{table.to_s.camelize}".constantize.new(data)
    model.save!
  end
end

# 技能
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_art_types")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_arts")
art_types = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/art.yml")).result)
art_types.each do |art_type|
  #p art_type.except("attributes")
  art_type_model = GameData::ArtType.new(art_type.except("attributes"))
  art_type["attributes"].each do |art|
    #p art
    art_type_model.arts.build(art)
  end
  art_type_model.save!
end

# マップ
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_maps")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_map_tips")
map_names = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/map.yml")).result)
map_names.each do |map_name|
  #p map_name.except("attributes")
  map_name_model = GameData::Map.new(map_name.except("attributes"))
  map_name["attributes"].each do |map_tip|
    #p map
    map_name_model.map_tips.build(map_tip)
  end
  map_name_model.save!
end

# 能力, 武器, 技, 付加, 罠, アビリティ, キャラクター, 状態異常
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_ability_definitions")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_learning_conditions")
[:status, :weapon, :skill, :sup, :trap, :ability, :character, :disease].each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_#{table.to_s.tableize}")
  list = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/#{table}.yml")).result)
  parser    = EffectParser.new
  transform = EffectTransform.new
  list.each do |data|
    begin
      tree = parser.send("#{table}_definition").parse(data)
      tree = transform.apply(tree)
    rescue
      p "文法エラー"
      p data
    else
      data = { "name" => tree[:name].to_s, "definition" => data }
      data = data.merge(:kind =>    tree[:kind].keys.first.to_s) if tree[:kind].try(:respond_to?, :keys)
      data = data.merge(:color =>   tree[:color].to_s)   if tree[:color]
      data = data.merge(:caption => tree[:caption].to_s) if tree[:caption]
      #p data
      model = "GameData::#{table.to_s.camelize}".constantize.new(data)
      # アビリティー詳細
      if table == :ability
        check_first = true
        tree[:definitions].each do |effect|
          if effect[:pull_down].present?
            if check_first
              model.ability_definitions.build(:kind => :pull_down, :lv => 1, :caption => "無効")
              check_first = false
            end
            model.ability_definitions.build(:kind => :pull_down, :lv => effect[:lv], :caption => effect[:pull_down].to_s)
          else
            model.ability_definitions.build(:kind => :lv,        :lv => effect[:lv], :caption => effect[:caption].to_s)
          end
        end
      end
      # 習得条件
      if tree[:learning_conditions].present?
        condition_group = 1
        if tree[:learning_conditions][:or].present?
          tree[:learning_conditions][:or].each do |condition_or|
            if condition_or[:and].present?
              group_count = condition_or[:and].count
              condition_or[:and].each do |condition|
                condition[:name] = condition[:name].to_s
                model.learning_conditions.build(condition.merge({ :condition_group => condition_group, :group_count => group_count }))
              end
            else
              group_count = 1
              condition_or[:name] = condition_or[:name].to_s
              model.learning_conditions.build(condition_or.merge({ :condition_group => condition_group, :group_count => group_count }))
            end
            condition_group = condition_group + 1
          end
        elsif tree[:learning_conditions][:and].present?
          group_count = tree[:learning_conditions][:and].count
          tree[:learning_conditions][:and].each do |condition|
            condition[:name] = condition[:name].to_s
            model.learning_conditions.build(condition.merge({ :condition_group => condition_group, :group_count => group_count }))
          end
        else
          group_count = 1
          tree[:learning_conditions][:name] = tree[:learning_conditions][:name].to_s
          model.learning_conditions.build(tree[:learning_conditions].merge({ :condition_group => condition_group, :group_count => group_count }))
        end
      end
      model.save!
    end
  end
end

# 訓練可能なものをまとめる
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_trains")
[:Job, :Status, :Art, :Product, :Ability].each do |class_name|
  "GameData::#{class_name}".constantize.find_each do |trainable|
    train = GameData::Train.new
    train.trainable = trainable
    train.visible = [:Job].any?{ |f| f==class_name } ? false : true
    train.save!
  end
end

# 単語自動リンク用のインデックス保存
tx_map = []
[:Job, :Guardian, :Status, :ArtType, :Art, :Word, :Disease, :BattleValue, :Product, :Element, :Point].each do |class_name|
  tx_map += "GameData::#{class_name}".constantize.all.map{ |a| [a.name, "#{class_name.to_s.tableize}/#{a.id}/#{a.color if a.respond_to?(:color)}"] }.flatten
end
builder = Tx::MapBuilder.new
builder.add_all(tx_map.flatten)
builder.build("#{Rails.root}/db/game_data/dnu")
