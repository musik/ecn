Capistrano::Configuration.instance.load do
  namespace :sphinx do
    desc "|DarkRecipes| Generates Configuration file for TS"
    task :config, :roles => :app do
      run "cd #{current_path}; #{rake_bin} RAILS_ENV=#{rails_env} ts:config"
    end

    desc "|DarkRecipes| Starts TS"
    task :start, :roles => :app do
      run "cd #{current_path}; #{rake_bin} RAILS_ENV=#{rails_env} ts:start"
    end

    desc "|DarkRecipes| ReStarts TS"
    task :restart, :roles => :app do
      run "cd #{current_path}; #{rake_bin} RAILS_ENV=#{rails_env} ts:restart"
    end

    desc "|DarkRecipes| Stops TS"
    task :stop, :roles => :app do
      run "cd #{current_path}; #{rake_bin} RAILS_ENV=#{rails_env} ts:stop"
    end

    desc "|DarkRecipes| Rebuild TS"
    task :rebuild, :roles => :app do
      run "cd #{current_path}; #{rake_bin} RAILS_ENV=#{rails_env} ts:rebuild"
    end

    desc "|DarkRecipes| Indexes TS"
    task :index, :roles => :app do
      run "cd #{current_path}; #{rake_bin} RAILS_ENV=#{rails_env} ts:in"
    end
    desc "|DarkRecipes| Pre Indexes TS"
    task :pi, :roles => :app do
      run "cd #{release_path}; #{rake_bin} RAILS_ENV=#{rails_env} ts:in"
      run "rm -rf #{shared_path}/db/sphinx"
      run "mv #{release_path}/db/sphinx #{shared_path}/db/"
    end

    desc "|DarkRecipes| Re-establishes symlinks"
    task :symlink do
      path = "/config/#{environment}.sphinx.conf"
      #run "if [ ! -f '#{shared_path}#{path}' ]; then cd #{current_path} && #{rake_bin} RAILS_ENV=#{rails_env} ts:config; mv #{current_path}#{path} #{shared_path}#{path}; fi;"
      run "cd #{current_path} && #{rake_bin} RAILS_ENV=#{rails_env} ts:config; mv #{current_path}#{path} #{shared_path}#{path};"
      run "rm -rf #{current_path}#{path} && ln -nfs #{shared_path}#{path} #{current_path}#{path}"
      run "if [ ! -d '#{shared_path}/config/db/sphinx' ]; then mkdir -p #{shared_path}/db/sphinx; fi;"
      run <<-CMD
        rm -rf #{current_path}/db/sphinx && ln -nfs #{shared_path}/db/sphinx #{current_path}/db/sphinx
      CMD
    end
  end
end
