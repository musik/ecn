#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
#require 'thinking_sphinx/deltas/delayed_delta/tasks'
#require 'thinking_sphinx/deltas/datetime_delta/tasks'
require 'resque/tasks'
require 'resque_scheduler/tasks'
Ecn::Application.load_tasks
