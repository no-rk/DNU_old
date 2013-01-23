# rake pegjs
desc "compile pegjs in app/assets/javascripts/plugins"
task :pegjs do
  files = Dir.glob("#{Rails.root}/app/assets/javascripts/plugins/*.pegjs")
  files.each do |file|
    `pegjs -e parser #{file}`
  end
end
