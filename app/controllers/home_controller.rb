class HomeController < ApplicationController
  include ApplicationHelper
  def status
    @data = {
      :topic => Topic.count,
      :company => Company.count,
      :product => Product.count
    }
    render :json=>@data
  end
  def index
      @topics1 = @current_app.topics.popular.limit(30)
      @topics2 = @current_app.topics.recent.present.limit(30)
      @products = @current_app.products.recent.short.limit(19)
      @companies = @current_app.companies.recent.short.limit(10)
  end
  def recent
    @topics = @current_app.topics.recent.present.page(params[:page] || 1).per(100)
    render :action=>'topics'
  end
  def popular
    @topics = @current_app.topics.popular.present.page(params[:page] || 1).per(100)
    @title = 'Popular'
    render :action=>'topics'
  end
  def test
    @classify = NaiveBayes.new [:adult,:normal]
    #@classify = NaiveBayes.new :adult,:normal
    @topics2 = Topic.limit(30).all
    @topics = Topic.search('sex vagina penis anus pussy ass viagra vibrator dildos lubes adult inflatable toys breast enlargement',:per_page=>20,:match_mode=>:any)
    @products = Product.search('sex vagina penis anus pussy ass viagra vibrator dildos lubes adult inflatable toys breast enlargement',:per_page=>20,:match_mode=>:any)
    @products2 = Product.limit(30).all
    #@products.each do |t|
      #@classify.train :adult,t.title
    #end
    #@products2.each do |t|
      #@classify.train :normal,t.title
    #end
  end
  def search
    @q = params[:q]
    _check_adult @q
    @prods = cache "search-#{@q}-show-#{params[:page]}",:expires_in=>1.day do
      Product.search(@q,
        :page=>params[:page],
        :include=>[:company],
        :sort_mode => :extended,
        :order => "@relevance DESC,created_at DESC",
        :per_page => 20
        )
    end
    @topics = Topic.search(@q,
        :without => {:products_count=>0}, 
        :match_mode => :any,
        :sort_mode => :extended,
        :includes => [:app],
        :order => "@relevance DESC",
        :page=> params[:page],
        :per_page=>20)
    @title = "search '#{@q}'"
  end
  def archive
    @groups = Topic.search(nil,
        :with => {:app_id=>@current_app.id}, 
        :group_by => 'created_at',
        :group_function => :day,
        :sort_mode => :extended,
        :order => '@group DESC',
        :page=> params[:page],
        :per_page=>100)
  end
  def day
    @day = Date.parse params[:day]
    @nextday = @day + 1
    @topics = Topic.search(
        :with => {:app_id=>@current_app.id,:created_at=>@day..@nextday}, 
        :page=> params[:page],
        :per_page=>100
      )
    @groups = Topic.search(
        :with => {:app_id=>@current_app.id}, 
        :group_by => 'created_at',
        :group_function => :day,
        :order_group_by => '@group DESC',
        :per_page=>30)
  end

  def topic
    @topic = Topic.find_by_slug params[:topic_name]
    _check_adult @topic.name
    @name = @topic.name
    @prods = cache "topic-#{@name}-show-#{params[:page]}",:expires_in=>1.day do
      Product.search(@name,
        :page=>params[:page],
        :include=>[:company],
        :sort_mode => :extended,
        :order => "@relevance DESC,created_at DESC",
        :per_page => 20
        )
    end
    if @topic.present? and @topic.products_count != @prods.total_entries or Rails.env.development?
      #@topic.update_attribute :products_count,@prods.total_entries
      @update_count = @prods.total_entries
    end

    @related = Topic.search(@topic.name,
        :without => {:products_count=>0,:id=>@topic.id}, 
        :match_mode => :any,
        :sort_mode => :extended,
        :order => "@relevance DESC",
        :per_page=>10)
    @random = Topic.random(10)

  end
  def update_count
    @topic = Topic.find_by_slug params[:topic_name]
    count = Product.search_count @topic.name
    @topic.update_attribute(:products_count,count) if count != @topic.products_count
    render :nothing=>true
  end
  def product
    @pro = Product.find_by_url params[:product_url]
    _check_adult @pro.title
  end
  def company 
    @company = Company.find_by_slug params[:company_url]
  end
  def _check_adult str
    if is_adult? str
      @is_adult = true
      #@title = str
      #render "home/adult",:status=>410
      #return
    end
  end
end
