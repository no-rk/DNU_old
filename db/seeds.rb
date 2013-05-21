# encoding: UTF-8

ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_trains")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_learning_conditions")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_map_tips")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_enemy_list_elements")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_event_steps")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_event_contents")

# 日付
if Day.last.nil?
  Day.create!(:day => 0, :state => 2)
end

# 戦闘値, 属性, アイテム種類, 装備種, 地形, 戦闘種類, 戦闘設定, 技能種類, 技能, 守護, ポイント, ポイント使用
[:battle_value, :element, :item_type, :equip_type, :landform, :battle_type, :battle_setting, :art_type, :art, :guardian, :point, :point_use].each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_#{table.to_s.tableize}")
  list = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/#{table}.yml")).result)
  list[:data].try(:each) do |data|
    model = "GameData::#{table.to_s.camelize}".constantize.new(data)
    model.save!
  end
end

# マップ, 能力, 状態異常, 装備, 付加, 罠, 技, 戦物, 使用
[:map, :status, :disease, :equip, :sup, :trap, :skill, :item_skill, :item_use].each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_#{table.to_s.tableize}")
  list = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/#{table}.yml")).result)
  list[:data].try(:each) do |data|
    model = "GameData::#{table.to_s.camelize}".constantize.new
    model.definition = data
    model.save!
  end
end

# キャラクター種類, 技能効果, 特殊効果記述法, イベント記述法, 言葉
[:character_type, :art_effect, :effect_description, :event_description, :word].each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_#{table.to_s.tableize}")
  list = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/#{table}.yml")).result)
  list[:data].try(:each) do |data|
    model = "GameData::#{table.to_s.camelize}".constantize.new(data)
    model.save!
  end
end

# アイテム, キャラクター, 敵リスト, 敵出現地, イベント
[:item, :character, :enemy_list, :enemy_territory, :event].each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_#{table.to_s.tableize}")
  list = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/#{table}.yml")).result)
  list[:data].try(:each) do |data|
    model = "GameData::#{table.to_s.camelize}".constantize.new
    model.definition = data
    model.save!
  end
end

# 単語自動リンク用のインデックス保存
tx_map = {}
[:art_type, :art, :battle_type, :battle_value, :battle_setting, :character_type, :disease, :element, :equip_type, :equip, :guardian, :item_type, :landform, :map, :point,  :status, :effect_description, :event_description, :word].each do |table|
  "GameData::#{table.to_s.camelize}".constantize.find_each do |r|
    tx_map[r.name] ||= []
    h = {
      model: "GameData::#{table.to_s.camelize}",
      id: r.id
    }
    h.merge!(color: r.color) if r.respond_to?:color
    tx_map[r.name].push(h)
  end
end
builder = Tx::MapBuilder.new
builder.add_all(tx_map.map{|(k,v)| [k, v.to_json] }.flatten)
builder.build("#{Rails.root}/db/game_data/dnu")
