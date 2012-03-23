class TweetData
  def initialize(tweet_id, tweeted_at)
    @tweet_id = tweet_id
    @tweeted_at = tweeted_at
  end

  def diffaize(diffaizer)
    if diffaizer.respond_to?(:diffaize)
      diffaizer.diffaize(@tweet_id, @tweeted_at)
    else
      []
    end
  end
end

