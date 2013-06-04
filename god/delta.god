rails_env   = ENV['RAILS_ENV']  || "production"
rails_root  = ENV['RAILS_ROOT'] || "/home/muzik/ecn/current"
num_workers = rails_env == 'production' ? 1 : 1

God.watch do |w|
  w.log      = "#{rails_root}/log/god.log"
  w.dir      = "#{rails_root}"
  w.name     = "resque-ecn-delta"
  w.group    = 'resque-ecn'
  w.interval = 900.seconds
  w.start    = "cd #{rails_root} && RAILS_ENV=#{rails_env} bundle exec rake resque:work QUEUE=ts_delta INTERVAL=900"
  w.keepalive
end
