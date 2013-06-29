require 'ali/parser'
require 'ali/queues'
require 'ali/company_fetcher'
module Ali
  class Core
  def initialize
  end
  def prepare
    #url = 'http://www.alibaba.com/showroom/showroom.html'
    url = 'http://www.alibaba.com/Products'
    doc = fetch_url url
    parse_topic_links doc
  end
  def reset_urls
    @redis ||= Resque.redis
    @redis.del "aliurls"
  end
  def clean_urls pros=false
    @redis ||= Resque.redis
    key = 'aliurls'
    @redis.smembers(key).each do |str|
      @redis.srem(key,str) if is_prod_url? str
    end
  end
  def clean_topic_jobs
    @redis ||= Resque.redis
    key = 'queue:topic'
    size =  @redis.llen key
    Range.new(0,size).each do |i|
      val = @redis.lindex(key,i)
      next if val.nil?
      val = JSON.parse(val)
      next if is_category_url? val["args"].first
      Resque::Job.destroy('topic',val["class"],*(val["args"]))
    end
  end
  def topic_jobs_uniq
    @redis ||= Resque.redis
    key = 'queue:topic'
    size =  @redis.llen key
    data = []
    #Range.new(0,size).each do |i|
      #str = @redis.lindex(key,i)
    @redis.lrange(key,0,-1).each do |str|
      #puts str
      next if str.nil?
      val = JSON.parse(str)
      arg = val["args"].first
      if arg.nil? or data.include?(arg)
        @redis.lrem key,-1,str
      else
        data << arg
      end
    end
    puts data
  end
  def url_exist? url
    @redis ||= Resque.redis
    key = 'aliurls'
    val = url.match(/http\:\/\/[^\/]+\/(.+)$/)[1]
    return true if @redis.sismember key,val
    @redis.sadd key,val
    false
  end
  
  def parse_topic_links doc
    if doc
      slugs = []
      doc.css('a').each do |link|
        next unless link.attr("href").present?
        slugs << topic_url_to_slug(link.attr("href"))
      end
      slugs = slugs.compact.uniq
      exists = Topic.where(:slug=>slugs).pluck(:slug)
      slugs -= exists if exists
      slugs.each do |slug|
        Resque.enqueue Queues::TopicQ,slug
      end
    end

  end
  def parse_company_links doc
    if doc
      urls = []
      doc.css('a.company').each do |link|
        next unless link.attr("href").present?
        urls << link.attr("href") if is_company_url?(link.attr("href"))
      end
      urls.uniq.each do |href|
        next if url_exist? href
        Resque.enqueue Queues::CompanyQ,href
        #next if Kv.find_by_k(href).present?
        #Kv.create(:k=>href)
        #Company.delay(:priority=>7).import_from_url(href)
      end
    end
  end
  def topic_url_to_slug url
    url.match(/http:\/\/www.alibaba.com\/showroom\/([a-z0-9\-]+)\.html/)[1] rescue nil
  end
  def parse_product_links doc,limit=10
    if doc
      urls = [] 
      doc.css('a').each do |link|
        next unless link.attr("href").present?
        urls << link.attr("href").match(/^.+?\.html/).to_s if is_product_url?(link.attr("href"))
      end
      urls.uniq.slice(0,limit).each do |href|
        #next if url_exist? href
        Resque.enqueue Queues::ProductQ,href      
        #next if Kv.find_by_k(href).present?
        #Kv.create(:k=>href)
        #delay(:priority=>8).fetch_product(href)
      end
    end
  end
  def fetch_topic url,find_products = true
      slug = topic_name_from_url url
      if slug.nil?
        slug = url
        url = "http://www.alibaba.com/showroom/#{slug}.html"
      end
      return if Topic.exists? :slug=>slug
      doc = fetch_url url
      if doc
          name = doc.title.match(/^[^,]+/).to_s.downcase
          return if name.count(" ") > 3
          topic = Topic.where(:name=>name).first_or_create
          #parse_company_links doc
          parse_product_links doc if find_products
          parse_topic_links doc
          topic
      end
  end
  def fetch_company url
   CompanyFetcher.new(url).fetch_company 
  end
  def fetch_product url
    return if Product.exists?(:trackback=>url)
    doc = fetch_url url
    if doc
      data =  Parser.new.parse_product_page doc,url
      p = Product.import_data data
      parse_topic_links doc
      p
    end
  end
  def topic_name_from_url url
    ms = url.match(/www.alibaba.com\/([\w-]+)_pid\d+$/)
    return ms[1] unless ms.nil?
    ms = url.match(/www.alibaba.com\/showroom\/([\w-]+).html$/)
    return nil if ms.nil? or ms[1] == "showroom"
    ms[1]

  end
  def is_company_url? url
    (url =~ /\/\/([^\.]+)(?:\.(?:en|trustpass))\.alibaba.com\/*$/ or 
      url =~ /\/\/www.alibaba.com\/member\/[^\.]+.html/).present?
  end
  def is_product_url? url 
    (url =~ /:\/\/www.alibaba.com\/product-(?:gs|tp|free)\/\d+\/.+?\.html/).present?
  end
  def is_topic_url? url
    (url =~ /www.alibaba.com\/[\w-]+_pid\d+$/ or url =~ /www.alibaba.com\/showroom\/[\w-]+.html$/).present? and url.match(/www.alibaba.com\/showroom\/showroom(-\w)*.html/).nil?
  end
  def is_category_url? url
      url.match(/www.alibaba.com\/[a-z\-]+_p(id)*\d+$/i).present?
  end
  def is_dirty_url? url
      url.match(/^[a-z\-]+_p(id)*\d+(_\d+|\?)/i).present?
  end
  def is_prod_url? url
      url.match(/^product-(gs|free|tp).+/i).present?
  end
  def fetch_url url
    response = Typhoeus::Request.get(url,:headers=>{"Referer"=>"http://www.alibaba.com","User-Agent"=>"Soso"})
    if response.success?
      return Nokogiri::HTML(response.body)
    end
    false
  end
  end
end
