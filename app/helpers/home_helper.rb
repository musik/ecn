module HomeHelper
  def sanitize_desc str
    str.gsub(/aliDataTable/,'table table-bordered').html_safe
  end
  def url_valid? str
    str.present? and str.match(/^http:\/\/[^\/]+\/*$/).present?
  end
  def link_to_external str,href
    link_to str,href,:rel=>"nofollow",:target=>"_blank"
  end
end
