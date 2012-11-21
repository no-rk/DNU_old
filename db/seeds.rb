#ジョブ
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_jobs")
jobs = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/job.yml")).result)
jobs.each do |job|
  p job
  job_model = GameData::Job.new(job)
  job_model.save!
end

#守護
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_guardians")
guardians = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/guardian.yml")).result)
guardians.each do |guardian|
  p guardian
  guardian_model = GameData::Guardian.new(guardian)
  guardian_model.save!
end

#ステータス
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_statuses")
statuses = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/status.yml")).result)
statuses.each do |status|
  p status
  status_model = GameData::Status.new(status)
  status_model.save!
end

#技能
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

#アビリティ
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_abilities")
abilities = YAML.load(ERB.new(File.read("#{Rails.root}/db/game_data/ability.yml")).result)
abilities.each do |ability|
  p ability
  ability_model = GameData::Ability.new(ability)
  ability_model.save!
end
