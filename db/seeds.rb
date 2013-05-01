# encoding: UTF-8

ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_trains")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_learning_conditions")

# 日付
if Day.last.nil?
  Day.create!(:day => 0, :state => 2)
end

# 戦闘値, 属性, アイテム種類, 装備種, キャラクター種類, 地形, ポイント, 戦闘設定, 技能種類, 技能, 守護
[:battle_value, :element, :item_type, :equip_type, :character_type, :landform, :point, :battle_setting, :art_type, :art, :guardian].each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_#{table.to_s.tableize}")
  list = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/#{table}.yml")).result)
  list[:data].each do |data|
    model = "GameData::#{table.to_s.camelize}".constantize.new(data)
    model.save!
  end
end

# 言葉
[:word].each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_#{table.to_s.tableize}")
  list = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/#{table}.yml")).result)
  list.each do |data|
    #p data
    model = "GameData::#{table.to_s.camelize}".constantize.new(data)
    model.save!
  end
end

# マップ, 能力, 状態異常, 装備, 付加, 罠, 技, 戦物, 使用, アビリティ, アイテム, キャラクター, 敵リスト, 敵出現地, イベント
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_map_tips")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_ability_definitions")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_enemy_list_elements")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_event_steps")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_event_contents")
[:map, :status, :disease, :equip, :sup, :trap, :skill, :item_skill, :item_use, :ability, :item, :character, :enemy_list, :enemy_territory, :event].each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_#{table.to_s.tableize}")
  list = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/#{table}.yml")).result)
  list[:data].each do |data|
    model = "GameData::#{table.to_s.camelize}".constantize.new
    model.definition = data
    model.save!
  end
end

# 単語自動リンク用のインデックス保存
tx_map = []
[:Guardian, :Status, :ArtType, :Art, :Word, :Disease, :BattleValue, :Element, :Point].each do |class_name|
  tx_map += "GameData::#{class_name}".constantize.all.map{ |r| [r.name, "#{class_name.to_s.tableize}/#{r.id}/#{r.color if r.respond_to?(:color)}"] }.flatten
end
builder = Tx::MapBuilder.new
builder.add_all(tx_map.flatten)
builder.build("#{Rails.root}/db/game_data/dnu")
