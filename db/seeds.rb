# encoding: UTF-8

# ジョブ, 守護, ステータス, 言葉
[:job, :guardian, :status, :word].each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_#{table.to_s.tableize}")
  list = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/#{table}.yml")).result)
  list.each do |data|
    p data
    model = "GameData::#{table.to_s.camelize}".constantize.new(data)
    model.save!
  end
end

# 技能
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_art_types")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_arts")
art_types = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/art.yml")).result)
art_types.each do |art_type|
  p art_type.except("attributes")
  art_type_model = GameData::ArtType.new(art_type.except("attributes"))
  art_type["attributes"].each do |art|
    p art
    art_type_model.arts.build(art)
  end
  art_type_model.save!
end

# アビリティ
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_abilities")
abilities = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/ability.yml")).result)
abilities.each do |ability|
  p ability
  ability_model = GameData::Ability.new(ability)
  ability_model.save!
end

# 付加
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_sups")
sups = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/sup.yml")).result)
parser = EffectParser.new
sups.each do |sup|
  begin
    tree = parser.sup_definition.parse(sup)
  rescue
    p "文法エラー"
    p sup
  else
    sup = { "name" => tree[:name].to_s, "definition" => sup }
    p sup
    sup_model = GameData::Sup.new(sup)
    sup_model.save!
  end
end

# 単語自動リンク用のインデックス保存
tx_map = []
[:Job, :Guardian, :Status, :ArtType, :Art, :Word].each do |class_name|
  tx_map += "GameData::#{class_name}".constantize.select([:name, :id]).map{ |a| [a.name, "#{class_name}/#{a.id}"] }.flatten
end
builder = Tx::MapBuilder.new
builder.add_all(tx_map.flatten)
builder.build("#{Rails.root}/db/game_data/dnu")
