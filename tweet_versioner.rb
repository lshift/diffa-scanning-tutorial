require 'singleton'
require 'digest/md5'

class TweetVersioner
  include Singleton

  def version_for(id, tweeted_at)
    Digest::MD5.hexdigest(id + tweeted_at)
  end
end

