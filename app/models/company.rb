class Company < ActiveRecord::Base
  attr_accessible :name, :slug, :country, :state, :city, :address, :opera_address, :zip, :phone, :mobile, :fax, :website, :aliexpress, :email, :btypes, :main_products, :contact, :trackback, :fetched, :meta,:description
 validates_presence_of :name,:slug
 acts_as_url :name,:url_attribute=>:slug,:only_when_blank=>true
 has_many :products
  belongs_to :app
  scope :recent,order("id desc")
  scope :short,select([:name,:slug])
  before_create :setapp
  scope :quick_search,lambda{|q,limit,options={}|
    search q,{:match_mode=>:any,:per_page=>limit}.merge(options).to_options
  }
  define_index do
    indexes name
    indexes description
    indexes country,state,city
    has id
    set_property :delta => ThinkingSphinx::Deltas::ResqueDelta
  end
  def related limit=10,short=true
    ids = self.class.search_for_ids name,:match_mode=>:any,:per_page=>limit,:without=>{:id=>id}
    self.class.where(:id=>ids).short
  end
  def setapp
    self.app = APPS[APPS.keys.sample]
  end
 def to_param
   slug
 end
  def app_url
    "http://#{SUBD}.#{domain}/c-#{slug}"
  end
  def domain
    @domain ||= fastapp.domain
  end
  def fastapp
    @fastapp ||= APPS[app_id]
  end
 def city_str
    [country,state,city].join(' - ').titleize
 end
 def import_profile
  data = Ali::CompanyFetcher.new(trackback).fetch_about_data
  update_attributes data
 end
 def import_data
  data = Ali::CompanyFetcher.new(trackback).fetch_contact_data
  update_attributes data
 end
 class CompanyQi
   @queue = "com_data"
   def self.perform id
     Company.find(id).import_data
   end
 end
 class << self
   def import data
     e = find_by_trackback data[:trackback]
     if e.present?
       e.update_attributes data
     else
       e = self.create(data)

       Resque.enqueue CompanyQi,e.id if e.fetched.nil?
       #e.delay(:priority=>5).import_data if e.fetched.nil?
       #e.delay(:priority=>6).import_profile
     end
     e
   end
   def import_from_url url
     import(Ali::CompanyFetcher.new(url).fetch_contact_data) 
   end
 end
end
