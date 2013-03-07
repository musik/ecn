module Ali
  class Parser
    include ActionView::Helpers::SanitizeHelper
    def sanitize_description(text)
      c = HTMLEntities.new
      # 
      text = c.encode text,:named
      text.gsub!(/&nbsp;/,' ')
      text = c.decode text
      text = sanitize(text,:tags=>%w(table tr td th p br img strong)).gsub(/<p>\s*<\/p>/,'')
      
      text
      # HTML
    end
    def parse_product_page doc,url
      title = doc.at_css('#productTitle').text rescue nil
      return unless title.present?
      data ={
        :title => title,
        :trackback => url,
        :image_src => (doc.at_css('#bigImage').attribute("src").to_s rescue nil),
        :description => (doc.at_css('#richTextDescription').inner_html.ftrip rescue nil)
      }
      unless data[:description].nil?
        # pp data[:description].length
        data[:description] = sanitize_description(data[:description])
        # pp data[:description].length 
      end
      
      hs = {}
      doc.css("#productTbInfo tr").each do |t|
        arr = t.text.gsub(/\s+/,' ').strip.split(": ")
        hs[arr[0].to_url] = arr[1]
      end
      hs.delete("custom-order")
      hs["fob-price"] = hs["fob-price"].gsub(/Get Latest Price/,'').strip
      data[:price] = hs
      
      data[:meta] = parse_product_meta(doc)
      data[:company] = parse_product_company doc
      data[:fetched] = true
      data
      
      # Product.import(data)
    end
    def parse_product_meta doc
      data = {}
      doc.css('#con_PDtab .ue-box-title').each do |t|
        # group = t.text
        node = t.next_element
        if node.name == 'table'
          vs = {}
          node.css('tr').each do |tr|
            arr = tr.text.ftrip.split(": ")
            vs[arr[0].to_url] = arr[1]
          end
        elsif node.name == 'p'
          vs = node.inner_html
        end
        data[t.text.to_url] = vs
      end
      data
    end
    def parse_product_crumbs doc
      as = doc.css('.crumb a')
      @parent = nil
      as = as.slice(2,10)
      as.each do |a|
        # k = h.decode(a.text()).sub(/[ ]+/,'').strip
        k = a.text.strip
        v = a.attribute('href').to_s
        if pid = v.scan(/_pid(\d+)/).to_s and pid.present?
          v = pid
        else
          v = "http://www.alibaba.com" + v
        end
        @c = Category.find_by_trackback(v)
        unless @c.present?
          @c = Category.create(:name=>k,:trackback=>v)
          @c.move_to_child_of(@parent) if @parent.present? 
        end
        @parent = @c
      end
      @parent
    end
    def parse_product_company doc
      node = doc.at_css('#companyName')
      return nil if node.nil? and doc.at_css('.uv-company').present?
      data = {
        :name => node.text.strip,
        :trackback => node.attribute("href").to_s,
        # :btypes => doc.at_css('#businessType').text
      }
      Company.import(data)
    end

    #从产品页读取公司网址并抓取公司页
    def parse_company_from_product doc
      url = doc.at_css('#companyName').attribute("href").to_s
      company = Company.find_by_trackback url
      if company.nil?
        company = fetch_company_data url
      end
      company
    end
    def fetch_company_data url
      CompanyFetcher.new(url).fetch_company
    end
    def fetch_company_contact_page url
      cf = CompanyFetcher.new url
      page = cf.fetch_contact_page
      parse_company_contact_page page
    end
    def fetch_company_about_page url
      cf = CompanyFetcher.new url
      page = cf.fetch_about_page
      parse_company_about_page page
    end
    def parse_company_about_page doc
      data = {
        #:name => doc.at_css('.corpName h1').text.ftrip,
        # :trackback => doc.at_css('.corpName h1 a').attribute("href").to_s,
      }
      meta = {}
      data[:description] = doc.at_css('.corp-show').parent().at_css('p').text.strip
      
       
      doc.at_css('.company-introduction-wrap').next_element().css('table.table-1 tr').each do |tr|
          meta[tr.at_css('th').text.strip.to_url] = tr.css('td')[1].text.strip
      end
      
      data[:btypes] = meta.delete("business-type").split(',').collect{|str| str.to_url} if meta.has_key?("business-type")
      data[:main_products] = meta.delete "main-products"
      meta.delete "company-name"
      data[:meta] = meta
      data
    end
    def parse_another_contact_page doc
      data = {}
      data[:name] = doc.at_css('.mod-shopsign-name').text.ftrip 
      ms = {}
      doc.css('.company-contact-information .table>tr').each do |tr|
        k = tr.at_css('th').text.ftrip.gsub(/:/,'')
        ms[k] = tr.css('td')[1].text.ftrip
      end
      #i = 0
      doc.css('.contact-detail dl dt').each do |dt|
        k = dt.text.ftrip.gsub(/:/,'')
        #ms[k] = dt.parent().css('dd')[i].text.ftrip
        ms[k] = dt.next_element().text.ftrip
        #i+=1
      end
      # pp ms
      ms["Contact Person"] = doc.at_css('.contact-info h1').text.ftrip rescue nil
      # pp ms
      
      hs = {
        :zip=>nil,
        :fax=>nil,
        :website=>nil,
        :address=>'Address',
        :opera_address=>'Operational Address',
        :phone=>'Telephone',
        :mobile=>'Mobile Phone',
        :contact=>'Contact Person',
        :city=>nil,
        :state=>'Province/State',
        :country=>'Country/Region',
        :aliexpress=>'Aliexpress.com Store',
        :trackback => 'Website on alibaba.com'
      }
      hs.each do |k,v|
        v = k.to_s.capitalize if v.nil?
        data[k] = ms.delete v
      end
      [:country,:state,:city].each do |k|
        next unless data.has_key? k
        data[k].downcase! unless data[k].nil? 
      end
      
      data.delete_if{|k,v| v.nil? or v.empty?}
      data[:fetched] = data.empty? ? false : true
      data
    end
    def parse_company_contact_page doc
      data = {
        :name => (doc.at_css('.corpName h1').text.ftrip rescue nil)
        # :trackback => doc.at_css('.corpName h1 a').attribute("href").to_s,
        # :btypes => doc.at_css('#businessType').text
      }
      if data[:name].nil?
        return (parse_another_contact_page(doc) rescue nil)
      end

      ms = {}
      # pp doc
      doc.css('.company-contact-information .table-1>tr').each do |tr|
        k = tr.at_css('th').text.ftrip.gsub(/:/,'')
        ms[k] = tr.css('td')[1].text.ftrip
      end
      #i = 0
      doc.css('#sub-person-info-list dt').each do |dt|
        k = dt.text.ftrip.gsub(/:/,'')
        #ms[k] = dt.parent().css('dd')[i].text.ftrip
        ms[k] = dt.next_element().text.ftrip
        #i+=1
      end
      # pp ms
      ms["Contact Person"] = doc.at_css('.main-person-info .profile h5').text.ftrip rescue nil
      # pp ms
      
      hs = {
        :zip=>nil,
        :fax=>nil,
        :website=>nil,
        :address=>'Address',
        :opera_address=>'Operational Address',
        :phone=>'Telephone',
        :mobile=>'Mobile Phone',
        :contact=>'Contact Person',
        :city=>nil,
        :state=>'Province/State',
        :country=>'Country/Region',
        :aliexpress=>'Aliexpress.com Store',
        :trackback => 'Website on alibaba.com'
      }
      hs.each do |k,v|
        v = k.to_s.capitalize if v.nil?
        data[k] = ms.delete v
      end
     # data[:location] = {}
     # [:country,:state,:city].each do |k|
     #   next unless data.has_key? k
     #   data[:location][k] = data[k].downcase unless data[k].nil? 
     #   data.delete(k)
     # end
      [:country,:state,:city].each do |k|
        next unless data.has_key? k
        data[k].downcase! unless data[k].nil? 
      end
      
      data.delete_if{|k,v| v.nil? or v.empty?}
      data[:fetched] = data.empty? ? false : true
      data
    end
  end
end
