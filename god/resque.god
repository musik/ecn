rails_env   = ENV['RAILS_ENV']  || "production"
rails_root  = ENV['RAILS_ROOT'] || "/home/muzik/ecn/current"
num_workers = rails_env == 'production' ? 1 : 1

God.watch do |w|
 w.log      = "#{rails_root}/log/god.log"
 w.dir      = "#{rails_root}"
 w.name     = "resque-ecn-scheduler"
 w.group    = 'resque-ecn'
 w.interval = 60.seconds
 w.start    = "cd #{rails_root} && RAILS_ENV=#{rails_env} bundle exec rake resque:scheduler"
 w.keepalive
end
#God.watch do |w|
  #w.log      = "#{rails_root}/log/god.log"
  #w.dir      = "#{rails_root}"
  #w.name     = "resque-ecn-delta"
  #w.group    = 'resque-ecn'
  #w.interval = 900.seconds
  #w.start    = "cd #{rails_root} && INTERVAL=900 RAILS_ENV=#{rails_env} bundle exec rake resque:work QUEUE=ts_delta"
  #w.keepalive
#end
num_workers.times do |num|
  God.watch do |w|
    w.log      = "#{rails_root}/log/god.log"
    w.dir      = "#{rails_root}"
    w.name     = "resque-ecn-#{num}"
    w.group    = 'resque-ecn'
    w.interval = 30.seconds
    #w.env      = {"QUEUE"=>"word", "RAILS_ENV"=>rails_env}
    #w.start    = "cd #{rails_root} && RAILS_ENV=#{rails_env} bundle exec rake resque:work QUEUE=ts_delta,topic_update,schedule,com_data,product,topic"
    w.start    = "cd #{rails_root} && RAILS_ENV=#{rails_env} bundle exec rake resque:work QUEUE=topic_update,schedule,com_data,product,topic"
#    w.start    = "bundle exec rake resque:work"

#    w.uid = 'muzik'
#    w.gid = 'muzik'

    # restart if memory gets too high
    w.transition(:up, :restart) do |on|
      on.condition(:memory_usage) do |c|
        c.above = 350.megabytes
        c.times = 2
      end
    end

    # determine the state on startup
    w.transition(:init, { true => :up, false => :start }) do |on|
      on.condition(:process_running) do |c|
        c.running = true
      end
    end

    # determine when process has finished starting
    w.transition([:start, :restart], :up) do |on|
      on.condition(:process_running) do |c|
        c.running = true
        c.interval = 5.seconds
      end

      # failsafe
      on.condition(:tries) do |c|
        c.times = 5
        c.transition = :start
        c.interval = 5.seconds
      end
    end

    # start if process is not running
    w.transition(:up, :start) do |on|
      on.condition(:process_running) do |c|
        c.running = false
      end
    end
  end
end
