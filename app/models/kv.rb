class Kv < ActiveRecord::Base
  attr_accessible :k, :v
  #after_create :delayed_job
  VS = {
    "topic" => 9,
  }
  def delayed_job
    if VS.has_key? v
      delay(:priority=>VS[v]).import_page 
    end
  end
  def import_page
    doc = Ali.new.fetch_url k
    if doc
      if v == "topic"
        k
      end
    end
  end
end
