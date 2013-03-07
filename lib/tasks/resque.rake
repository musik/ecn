namespace :resque do
  task :setup => :environment do
    Resque.schedule = YAML.load_file('config/scheduler.yml')
  end
end
