namespace :init do 
  desc "init all" 
  task :all => :environment do
    Topic.delete_all
    Product.delete_all
    Company.delete_all
    Kv.delete_all
    Delayed::Job.delete_all
    Ali::Core.new.prepare
  end
  desc "reset failed" 
  task :failed => :environment do
    @redis ||= Redis::Namespace.new("resque:ali",:redis=>Resque.redis.redis)
    @redis.del "failed"
    @redis.del "topic_products"
  end
  desc "init topics" 
  task :topics => :environment do
    Ali::Core.new.reset_urls
    Ali::Core.new.prepare
  end
  desc "init fix apps" 
  task :fix_apps => :environment do
    Topic.find_each do |p|
      #p.update_attribute :app_id,APPS.sample.id  
    end
    Company.find_each do |p|
      p.update_attribute :app_id,APPS.sample.id
      p.products.update_all :app_id=>p.app_id
    end
  end
end
