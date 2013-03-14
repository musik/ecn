namespace :resque do
  task :setup => :environment do
    Resque::Scheduler.dynamic = true

    Resque.schedule = YAML.load_file('config/scheduler.yml')
  end
end
