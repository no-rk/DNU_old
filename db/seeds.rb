# encoding: UTF-8

parser    = EffectParser.new
transform = EffectTransform.new

ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_trains")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_learning_conditions")

# 日付
if Day.last.nil?
  Day.create!(:day => 0, :state => 2)
end

# ジョブ, 守護, 言葉, 戦闘値, 生産, 属性, 戦闘設定, ポイント, 装備種, 地形
[:job, :guardian, :word, :battle_value, :product, :element, :battle_setting, :point, :equip_type, :landform].each do |table|
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
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_map_tips")
[:map].each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_#{table.to_s.tableize}")
  list = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/#{table}.yml")).result)
  list[:data].each do |data|
    model = "GameData::#{table.to_s.camelize}".constantize.new
    model.definition = data
    model.save!
  end
end

# アイテム種, 装備種
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_item_types")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_item_equips")
item_types = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/item_type.yml")).result)
item_types.each do |item_type|
  # p item_type.except("equip")
  item_type_model = GameData::ItemType.new(item_type.except("equip"))
  if item_type["equip"].present?
    # p item_type["equip"]
    begin
      tree = parser.equip_definition.parse(item_type["equip"])
      tree = transform.apply(tree)
    rescue
      p "文法エラー"
      p item_type["equip"]
    else
      item_type_model.build_item_equip
      item_type_model.item_equip.kind = tree[:kind].to_s
      item_type_model.item_equip.definition = item_type["equip"]
    end
  end
  item_type_model.save!
end

# 能力, 状態異常, 付加, 罠, 技, アビリティ, キャラクター, 敵リスト, 敵出現地 アイテム, イベント
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_ability_definitions")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_enemy_list_elements")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_event_steps")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_event_contents")
[:status, :disease, :sup, :trap, :skill, :ability, :character, :enemy_list, :enemy_territory, :item, :event].each do |table|
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
