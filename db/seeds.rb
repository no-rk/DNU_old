# encoding: UTF-8

ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_trains")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_learning_conditions")

# 日付
if Day.last.nil?
  Day.create!(:day => 0, :state => 2)
end

# 戦闘値, 属性
[:battle_value, :element].each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_#{table.to_s.tableize}")
  list = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/#{table}.yml")).result)
  list[:data].each do |data|
    model = "GameData::#{table.to_s.camelize}".constantize.new(data)
    model.save!
  end
end

# ジョブ, 守護, 言葉, 生産, 戦闘設定, ポイント, 装備種, 地形, キャラクター種類, アイテム種類
[:job, :guardian, :word, :product, :battle_setting, :point, :equip_type, :landform, :character_type, :item_type].each do |table|
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

# マップ, 能力, 状態異常, 装備, 付加, 罠, 技, 戦物, アビリティ, アイテム, キャラクター, 敵リスト, 敵出現地, イベント
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_map_tips")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_ability_definitions")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_enemy_list_elements")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_event_steps")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_event_contents")
[:map, :status, :disease, :equip, :sup, :trap, :skill, :item_skill, :ability, :item, :character, :enemy_list, :enemy_territory, :event].each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_#{table.to_s.tableize}")
  list = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/#{table}.yml")).result)
  list[:data].each do |data|
    model = "GameData::#{table.to_s.camelize}".constantize.new
    model.definition = data
    model.save!
  end
end

# 訓練可能なものをまとめる
[:Job, :Art, :Product].each do |class_name|
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
