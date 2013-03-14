# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.destroy_all   
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :name => 'muzik', :email => '58265826@qq.com', :password => 'PASSWORD', :password_confirmation => 'PASSWORD', :confirmed_at => Time.now.utc
puts 'New user created: ' << user.name
user.add_role :admin
