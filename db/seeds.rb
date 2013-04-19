# encoding: UTF-8

parser    = EffectParser.new
transform = EffectTransform.new

def clean_tree(tree)
  case tree
  when Hash
    tree.inject({}){ |h,(k,v)|
      h.tap{ h[k] = clean_tree(v) }
    }
  when Array
    tree.map{ |v| clean_tree(v) }
  when Parslet::Slice
    tree.to_s
  else
    tree
  end
end

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
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_maps")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_map_tips")
map_names = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/map.yml")).result)
map_names.each do |map_name|
  #p map_name.except("attributes")
  map_name_model = GameData::Map.new(map_name.except("attributes"))
  map_name["attributes"].each do |map_tip|
    #p map
    map_name_model.map_tips.build(map_tip.except("landform")) do |game_data_map_tip|
      game_data_map_tip.landform = GameData::Landform.find_by_image(map_tip["landform"])
    end
  end
  map_name_model.save!
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
      p data
    else
      item_type_model.build_item_equip
      item_type_model.item_equip.kind = tree[:kind].to_s
      item_type_model.item_equip.definition = item_type["equip"]
    end
  end
  item_type_model.save!
end

# 能力, 武器, 技, 付加, 罠, アビリティ, キャラクター, 状態異常, アイテム
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_ability_definitions")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_learning_conditions")
[:status, :weapon, :skill, :sup, :trap, :ability, :character, :disease, :item].each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_#{table.to_s.tableize}")
  list = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/#{table}.yml")).result)
  list.each do |data|
    begin
      tree = parser.send("#{table}_definition").parse(data)
      tree = transform.apply(tree)
    rescue
      p "文法エラー"
      p data
    else
      model = "GameData::#{table.to_s.camelize}".constantize.new
      data = { "name" => tree[:name].to_s, "definition" => data }
      if tree[:kind].try(:respond_to?, :keys) and model.respond_to?(:kind)
        data.merge!(:kind =>  tree[:kind].keys.first.to_s)
      elsif tree[:kind] and model.respond_to?(:kind)
        data.merge!(:kind =>  tree[:kind].to_s)
      end
      data.merge!(:color =>   tree[:color].to_s)   if tree[:color]   and model.respond_to?(:color)
      data.merge!(:caption => tree[:caption].to_s) if tree[:caption] and model.respond_to?(:caption)
      # p data
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

# イベント
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_events")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_event_steps")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_event_contents")
events = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/event.yml")).result)
events.each do |event|
  begin
    tree = parser.event_definition.parse(event)
    tree = transform.apply(tree)
    tree = clean_tree(tree)
  rescue
    p "文法エラー"
    p event
  else
    # Event
    model = GameData::Event.new
    model.kind    = (tree[:kind] || "通常").to_s
    model.name    = tree[:name].to_s
    model.caption = tree[:caption].to_s
    # EventStep
    tree[:steps].each do |step|
      model.event_steps.build do |event_step|
        event_step.timing    = step[:timing].keys.first.to_s
        event_step.condition = step[:condition].to_hash
        step[:contents].each do |content|
          event_step.event_contents.build do |event_content|
            event_content.kind    = content.keys.first
            event_content.content = content.values.first
          end
        end
      end
    end
    model.save!
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
