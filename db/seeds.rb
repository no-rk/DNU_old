#ジョブ
jobs = YAML.load_file("#{Rails.root}/db/game_data/job.yml")
jobs.each{|job|
  p job
  GameData::Job.create(job)
}
