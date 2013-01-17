# encoding: UTF-8

# ジョブ, 守護, ステータス, 言葉, 戦闘値, 生産, 属性
[:job, :guardian, :status, :word, :battle_value, :product, :element].each do |table|
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

# 技, 付加, アビリティ, キャラクター, 状態異常
[:skill, :sup, :ability, :character, :disease].each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_#{table.to_s.tableize}")
  list = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/#{table}.yml")).result)
  parser = EffectParser.new
  list.each do |data|
    begin
      tree = parser.send("#{table}_definition").parse(data)
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
      model.save!
    end
  end
end

# 単語自動リンク用のインデックス保存
tx_map = []
[:Job, :Guardian, :Status, :ArtType, :Art, :Word, :Disease, :BattleValue, :Product, :Element].each do |class_name|
  tx_map += "GameData::#{class_name}".constantize.all.map{ |a| [a.name, "#{class_name.to_s.tableize}/#{a.id}/#{a.color if a.respond_to?(:color)}"] }.flatten
end
builder = Tx::MapBuilder.new
builder.add_all(tx_map.flatten)
builder.build("#{Rails.root}/db/game_data/dnu")
