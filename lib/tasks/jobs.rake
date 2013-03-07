
namespace :jobs do 
  desc "update pros count" 
  task :topics => :environment do
    Topic.where(:products_count=>0).find_each do |t|
      #t.delay.update_products_count
    end
  end
end
