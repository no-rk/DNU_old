#ジョブ
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_jobs")
jobs = YAML.load_file("#{Rails.root}/db/game_data/job.yml")
jobs.each do |job|
  p job
  job_model = GameData::Job.new(job)
  p job["bonus"]
  #job_model.bonus = GameData::Bonus.new(job["bonus"])
  job_model.save!
end

#ステータス
ActiveRecord::Base.connection.execute("TRUNCATE TABLE game_data_statuses")
statuses = YAML.load_file("#{Rails.root}/db/game_data/status.yml")
statuses.each do |status|
  p status
  status_model = GameData::Status.new(status)
  p status["bonus"]
  #status_model.bonus = GameData::Bonus.new(status["bonus"])
  status_model.save!
end
