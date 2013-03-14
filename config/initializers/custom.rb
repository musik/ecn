def mylog o
  pp o if Rails.env.test?
end
class String
  def like(arr)
    arr.each do |str|
      return true if self =~ str
    end
    return false
  end
  def ftrip
    self.gsub(/\s+/,' ').strip
  end
end

APPS = App.all_hash# if Rails.env.production?
SUBD = Rails.env.production? ? "www" : "lo"


#ThinkingSphinx::Deltas::ResqueDelta::DeltaJob= 30 # seconds
#ThinkingSphinx::Deltas::ResqueDelta.throttle_interval= 30
