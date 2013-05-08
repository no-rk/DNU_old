# rake pegcoffee
desc "compile pegcoffee in app/assets/javascripts/plugins"
task :pegcoffee do
  files = Dir.glob("#{Rails.root}/app/assets/javascripts/plugins/*.pegcoffee")
  files.each do |file|
    `pegcoffee -e parser #{file}`
  end
end
