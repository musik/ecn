class App < ActiveRecord::Base
  attr_accessible :domain, :name
  has_many :topics
  has_many :companies
  has_many :products
  class << self
    def all_hash
      results = {}
      all.each do |r|
        results[r.id] = r
      end
      results
    end
  end
end
