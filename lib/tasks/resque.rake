namespace :resque do
  task :setup => :environment do
    Resque::Scheduler.dynamic = true

    Resque.schedule = YAML.load_file('config/scheduler.yml')
  end
  task "pool:setup" do
    # close any sockets or files in pool manager
    ActiveRecord::Base.connection.disconnect!
    # and re-open them in the resque worker parent
    Resque::Pool.after_prefork do |job|
      ActiveRecord::Base.establish_connection
    end    
  end  
end
