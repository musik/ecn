class Product < ActiveRecord::Base
  attr_accessible :title, :url, :image_src, :trackback, :company_id, :fetched, :price, :meta, :description,:company,:app_id
  acts_as_url :title,:url_attribute=>:url
  
  validates_presence_of :title
  
  belongs_to :company
  belongs_to :app
  scope :recent,order("id desc")
  scope :short,select([:title,:url])
  before_create :setapp
  def setapp
    self.app_id = self.company.app_id if self.company.present?
  end
  def app_url
    "http://#{SUBD}.#{domain}/p-#{url}"
  end
  def domain
    @domain ||= fastapp.domain
  end
  def fastapp
    @fastapp ||= APPS[app_id]
  end
  define_index do
    indexes title
    indexes description
    indexes company(:name),:as=>:company_name
    has id,created_at,updated_at

    set_property :delta => ThinkingSphinx::Deltas::ResqueDelta
    #set_property :delta => :datetime, :threshold => 70.minutes
    #set_property :delta => :delayed  
  end
  def to_param
    url
  end
  def related(limit=8)
    Rails.cache.fetch [:product_related,id,limit],:expires_in=>1.day do
      Product.search(title.downcase,
        :without => {:id=>id},
        #:include=>[:company],
        :match_mode => :any,
        :order => "@relevance DESC,created_at DESC",
        :per_page => limit
        )
    end
  end
  def related_topics(limit=20)
    @related_topics ||= Rails.cache.fetch "prods-related-#{id}-#{limit}",:expires_in=>1.day do
      Topic.search(title,
        #:without => {:products_count=>0},
        :match_mode => :any,
        :sort_mode => :extended,
        :order => "@relevance DESC",
        :per_page=>limit)
    end
  end  
  class << self
    def import_data data
     e = find_by_trackback data[:trackback]
     if e.present?
       e.update_attributes data
     else
       e = self.create(data)
     end
     e
    end
  end
end
