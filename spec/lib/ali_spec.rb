
require 'spec_helper'

describe Ali do
  it "should " do
    #Ali.new.prepare
    #Ali.new.import_page "http://www.alibaba.com/Women-s-Dress-Shoes_pid100001608"
    ali = Ali::Core.new
    #ali.reset_urls
    #ali.prepare
    
    #Ali::Queues::TopicQ.perform 'http://www.alibaba.com/Agriculture_p1'
    #Ali::Queues::ProductQ.perform 'http://www.alibaba.com/product-gs/565085040/high_quality_Wheat_Gluten.html'
    #ali.prepare
    #mylog ali.fetch_topic "http://www.alibaba.com/showroom/rice.html"
    #mylog ali.fetch_company "http://guanhuachina.en.alibaba.com/"
    #mylog ali.fetch_company "http://www.alibaba.com/member/lwaksmann.html"

    #mylog ali.fetch_product "http://www.alibaba.com/product-gs/432571077/Grey_Marble_Marble_Subway_Tile_Marble.html"
    #p= ali.fetch_product "http://www.alibaba.com/product-tp/117560563/Vertical_Milling_Machine_from_Japan_in.html"
    #mylog p
    #p= ali.fetch_product "http://www.alibaba.com/product-free/114953154/Potassium_sulphate_powder_and_granular.html"
    #mylog p
    #mylog p.description
    href = "http://www.alibaba.com/showroom/rice.html"
    #ali.delay(:priority=>9).fetch_topic(href)
    #ali.delay(:priority=>9).fetch_topic(href)
  end
  it  "should valid" do
    ali = Ali::Core.new
    ali.is_company_url?("http://www.alibaba.com/member/lwaksmann.html").should eql(true)
    ali.is_company_url?("http://eee.en.alibaba.com/").should eql(true)
    ali.is_company_url?("http://sourcing.alibaba.com/").should eql(false)
    ali.is_topic_url?("http://www.alibaba.com/showroom/showroom-A.html").should eql(false)
    ali.is_topic_url?("http://www.alibaba.com/showroom/showroom.html").should eql(false)
    ali.is_category_url?("http://www.alibaba.com/Cocoa-Beans_pid10502").should eql(true)
    ali.is_category_url?("http://www.alibaba.com/Agriculture_p1").should eql(true)
    ali.is_category_url?("http://www.alibaba.com/Agriculture_p1_2").should eql(false)
    ali.is_category_url?("http://www.alibaba.com/Agriculture_p1?tracelog").should eql(false)
    ali.is_topic_url?("http://www.alibaba.com/showroom/category/21/Office-%2526-School-Supplies.html").should eql(false)

    ali.is_dirty_url?("Agriculture_p1").should eql(false)
    ali.is_dirty_url?("Agriculture_p1_2").should eql(true)
    ali.is_dirty_url?("Agriculture_p1?tracelog").should eql(true)
    ali.is_prod_url?("product-gs/458111731/Advertising_Flyer_Ballpoint_Pen.html").should eql(true)
    ali.is_prod_url?("product-free/101584703/speedometer.html").should eql(true)
    ali.is_prod_url?("Agriculture_p1").should eql(false)

    #ali.url_exist?("http://www.alibaba.com/showroom/category.html").should eql(false)
    ali.url_exist?("http://www.alibaba.com/showroom/category.html").should eql(true)
    
  end
  it "should clean " do
    #Ali::Core.new.clean_topic_jobs
      #ali = Ali::Core.new
      #ali.clean_urls
  end
end
