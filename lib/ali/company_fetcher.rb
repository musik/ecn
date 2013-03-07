module Ali
  class CompanyFetcher
    def initialize url
      @url = url
      mylog url
      slug = url.match(/http:\/\/www.alibaba.com\/member\/([^\/]+?).html/)[1] rescue nil
      if slug.nil?
        @url_type = 1
        @contact_url = "#{url}/contactinfo.html"
        @about_url = "#{url}/company_profile.html"
      else
        @url_type = 2
        @contact_url = "http://www.alibaba.com/member/#{slug}/contactinfo.html"
        @about_url = "http://www.alibaba.com/member/#{slug}/company_profile.html"
      end
    end
    def fetch_company
      fetch_contact_data
    end
    def fetch_contact_data
      p = Parser.new
      page = fetch_contact_page
      return {} unless page
      data = p.parse_company_contact_page page 
      return {} unless data.present?
      mylog data
      data[:trackback] ||= @url
      data
    end
    def fetch_about_data
      p = Parser.new
      p.parse_company_about_page fetch_about_page
      
    end
    def fetch_data
      p = Parser.new
      data = p.parse_company_contact_page fetch_contact_page
      about = p.parse_company_about_page fetch_about_page
      data.merge! about
      data[:trackback] = @url
      # pp data
      data
    end
    def fetch_contact_page
      fetch @contact_url
    end
    def fetch_about_page
      fetch @about_url
    end
    def fetch url
      @http ||= Core.new 
      @http.fetch_url(url)
    end
  end
end
