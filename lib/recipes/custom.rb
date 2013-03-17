require 'erb'

Capistrano::Configuration.instance.load do
  namespace :app do
    desc "|Custom| Create database.yml in shared path with settings for current stage and test env"
    task :yml do      
      #run "if [ ! -d '#{shared_path}/config' ]; then mkdir -p #{shared_path}/config; fi;"
      #run "rm -rf #{shared_path}/config/database.yml"
      #upload './config/database.yml', "#{shared_path}/config/database.yml"
      #upload './config/application.yml', "#{shared_path}/config/application.yml"
      #upload './config/settings.yml', "#{shared_path}/config/settings.yml"
      #upload './config/taobaorb.yml', "#{shared_path}/config/taobaorb.yml"
      upload './config/resque.yml', "#{shared_path}/config/resque.yml"
    end 
    task :symlink do
      run "if [ ! -d '#{shared_path}/html' ]; then mkdir #{shared_path}/html; fi;"
      run "rm -rf #{release_path}/public/cache && ln -nfs #{shared_path}/html #{release_path}/public/cache"
      run "rm -rf #{release_path}/config/database.yml && ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
      run "rm -rf #{release_path}/config/resque.yml && ln -nfs #{shared_path}/config/resque.yml #{release_path}/config/resque.yml"
      #run "rm -rf #{release_path}/config/application.yml && ln -nfs #{shared_path}/config/application.yml #{release_path}/config/application.yml"
      #run "rm -rf #{release_path}/config/settings.yml && ln -nfs #{shared_path}/config/settings.yml #{release_path}/config/settings.yml"
      #run "rm -rf #{release_path}/config/taobaorb.yml && ln -nfs #{shared_path}/config/taobaorb.yml #{release_path}/config/taobaorb.yml"
    end
  end
  namespace :unicorn do
    task :symlink do
      run "rm -rf #{current_path}/config/unicorn.rb && ln -nfs #{shared_path}/config/unicorn.rb #{current_path}/config/unicorn.rb"
    end
  end
  namespace :nginx do
    task :restart2, :roles => :app , :except => { :no_release => true } do
      set :user,'root'
      run "service nginx restart"
    end
  end
  namespace :ss do
    task :rvm,:roles => :app do
      run "PATH=$PATH:$HOME/.rvm/bin;rvm use ruby-head"
    end
    task :uptime,:roles => :app do
      run "uptime"
    end
    task :bundle, :roles => :app do
      #run "which bundle"
      #run "gem install bundler"
    end
    task :update_rates, :roles => :app do
      run "cd #{current_path};RAILS_ENV=#{rails_env} bundle exec rails runner 'Shop::Import.new.update_all_rates'"
    end
  end
end
