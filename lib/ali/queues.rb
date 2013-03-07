module Ali
  module Queues 
    class CompanyQ
      @queue = "company"
      def self.perform url
        Company.import_from_url url 
      end
    end
    class ProductQ
      @queue = "product"
      def self.perform url
        Ali::Core.new.fetch_product url
      end
    end
    class TopicQ
      @queue = "topic"
      def self.perform url
        Ali::Core.new.fetch_topic url
      end
    end
  end
end
