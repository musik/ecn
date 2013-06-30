class TopicJob
  @queue = "topic"
  def self.perform url
    ::Ali::Core.new.fetch_topic url
  end
end
