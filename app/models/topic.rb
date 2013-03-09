class Topic < ActiveRecord::Base
  #@queue = "topic_products"
  attr_accessible :name, :products_count, :slug
  acts_as_url :name,:url_attribute=>:slug
  
  validates_presence_of :name
  validates_uniqueness_of :name

  before_save :ensure_name_downcase
  #after_create :update_products_count_in_future
  before_create :setapp
  belongs_to :app

  scope :popular,order("products_count desc")
  scope :recent,order("id desc")
  scope :short,select([:name,:slug])
  scope :present,where('products_count > 0 ')
  #scope :related,lambda{|str,limit|}
  before_save :set_delta_flag

  def set_delta_flag
    if changes["products_count"].present?
      self[:delta] = true
    end 
  end  
  
  def setapp
    self.app = APPS[APPS.keys.sample]
  end
  def app_url
    "http://#{SUBD}.#{domain}/#{slug}"
  end
  def domain
    @domain ||= fastapp.domain
  end
  def fastapp
    @fastapp ||= APPS[app_id]
  end
  define_index do
    indexes name
    indexes "left(slug,1)", :as => :start_with
    indexes "left(slug,2)", :as => :start_with2
    has :id
    has :products_count
    set_property :delta => ThinkingSphinx::Deltas::ResqueDelta
    #set_property :delta => :delayed  
   #set_property :delta => :datetime, :threshold => 70.minutes 
    
  end
  def to_param
    slug
  end
  def ensure_name_downcase
    name.downcase!
  end
  def title
    @title ||= name.capitalize
  end
  def update_products_count
    update_attribute :products_count,Product.search_count(name)
  end
  def update_products_count_in_future
    #update_products_count
  end
  #handle_asynchronously :update_products_count_in_future, :run_at => Proc.new { 70.minutes.from_now }

  class TopicQu
    @queue = "topic_update"
    def self.perform
      Topic.update_products_count_of_empty
    end
  end
  class << self
    def update_products_count_of_empty
      where(:products_count=>0).find_each do |t|
        #Resque.enqueue Topic,t.id 
        t.update_products_count
      end
    end
    #def perform id
    #  Topic.find(id).update_products_count
    #end
    def related str,limit=10,id=nil
      cond = {:products_count => 0}
      cond[:id] = id if id.present?
      Topic.search(str,
        :without => cond, 
        :match_mode => :any,
        :sort_mode => :extended,
        :order => "@relevance DESC",
        :per_page=>limit)
    end
  end
end