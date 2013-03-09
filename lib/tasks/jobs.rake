
namespace :jobs do 
  desc "update pros count" 
  task :topics => :environment do
    Resque.enqueue Topic::TopicQu
  end
end
