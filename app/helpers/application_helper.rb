module ApplicationHelper
  def app_topic_url t
    "http://www.#{t.domain}/#{t.slug}"
  end
  def is_adult? str
    str.match(/sex|vagina|penis|anus|pussy|ass|viagra|vibrator|dildos|lubes|adult|inflatable toys|breast enlargement/).present?
  end
end
