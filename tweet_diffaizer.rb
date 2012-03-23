require 'singleton'
require 'time'
require './tweet_versioner'

class TweetDiffaizer
  include Singleton

  def diffaize(tweet_id, tweeted_at)
    {id: tweet_id, attributes: {}, version: TweetVersioner.instance.version_for(tweet_id, tweeted_at), lastUpdated: Time.now.iso8601}
  end
end

class CategorizingTweetDiffaizer
  include Singleton

  def diffaize(tweet_id, tweeted_at)
    {id: tweet_id, attributes: {tweeted_at: tweeted_at}, version: TweetVersioner.instance.version_for(tweet_id, tweeted_at), lastUpdated: Time.now.iso8601}
  end
end

