require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']
source 'https://rubygems.org'
gem 'rails', '3.2.8'
gem 'mysql2'
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
gem 'jquery-rails'
gem "haml", ">= 3.1.6"
gem "haml-rails", ">= 0.3.4", :group => :development
gem "rspec-rails", ">= 2.11.0", :group => [:development, :test]
gem "database_cleaner", ">= 0.8.0", :group => :test
#gem "mongoid-rspec", "1.4.6", :group => :test
gem "factory_girl_rails", ">= 3.5.0", :group => [:development, :test]
gem "email_spec", ">= 1.2.1", :group => :test

group :development do
  gem 'libnotify'
  gem 'rb-inotify', :require => false
  gem "guard", ">= 0.6.2"
  gem "guard-bundler", ">= 0.1.3"
  gem "guard-rails", ">= 0.0.3"
  gem "guard-livereload", ">= 0.3.0"
  gem "guard-rspec", ">= 0.4.3"
  gem 'capistrano'
  #gem 'capistrano-ext'
  gem 'capistrano-recipes'
  gem 'capistrano-helpers'
  gem 'rvm-capistrano'
  gem 'capistrano-unicorn',:git=>'git://github.com/sosedoff/capistrano-unicorn.git'
  gem 'capistrano-resque'
end
gem "devise", ">= 2.1.2"
gem "cancan", ">= 1.6.8"
gem "rolify", ">= 3.1.0"
gem "bootstrap-sass", ">= 2.0.4.0"
gem "simple_form"
gem "therubyracer", :group => :assets, :platform => :ruby

gem 'typhoeus'
gem 'nokogiri'
gem "stringex"
gem 'breadcrumbs'
gem 'kaminari'
gem "htmlentities"

gem 'thinking-sphinx', '2.0.13'
#gem 'ts-datetime-delta', '1.0.3',:require => 'thinking_sphinx/deltas/datetime_delta'
#gem 'ts-delayed-delta', '1.1.3',:require => 'thinking_sphinx/deltas/delayed_delta'
gem 'ts-resque-delta', '~>1.2.4'
#gem 'ts-throttled-resque-delta', :git=>'git://github.com/acumenbrands/ts-throttled-resque-delta.git'

gem 'daemons'
gem 'whenever', :require => false

gem 'delayed_job_active_record'

gem 'rails_admin'

gem 'unicorn'

gem 'redis'
gem 'resque'
gem 'resque-scheduler', :require => 'resque_scheduler'
gem 'resque-cleaner'

gem 'god'
