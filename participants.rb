require 'rubygems'
require 'sinatra'
require 'time'
require 'json'
require 'singleton'
require 'digest/md5'
require './application_state.rb'
require './category.rb'
require './tweet_data'
require './tweet_diffaizer'

upstream_states = {
  :state1 => [
    TweetData.new('tweet1', '2012-03-01T14:30:10.000+00:00'),
    TweetData.new('tweet2', '2012-03-01T14:30:10.000+00:00'),
    TweetData.new('tweet3', '2012-03-01T14:30:10.000+00:00')
  ],
  :state2 => [
    TweetData.new('tweet1', '2012-03-01T14:30:10.000+00:00'),
    TweetData.new('tweet2', '2012-03-11T14:30:10.000+00:00'),
    TweetData.new('tweet3', '2012-03-13T14:30:10.000+00:00')
  ],
  :state3 => [
    TweetData.new('tweet1', '2012-03-01T14:30:10.000+00:00'),
    TweetData.new('tweet2', '2012-03-11T14:30:10.000+00:00'),
    TweetData.new('tweet3', '2012-03-13T14:30:10.000+00:00')
  ],
  :state4 => [
    TweetData.new('tweet2', '2012-01-01T22:30:10.000+00:00'),
    TweetData.new('tweet3', '2012-01-01T22:30:10.000+00:00'),
    TweetData.new('tweet4', '2012-01-01T22:30:10.000+00:00'),
    TweetData.new('tweet5', '2012-02-01T22:30:10.000+00:00'),
    TweetData.new('tweet6', '2012-02-01T22:30:10.000+00:00'),
    TweetData.new('tweet7', '2012-03-01T22:30:10.000+00:00'),
    TweetData.new('tweet8', '2012-03-01T22:30:10.000+00:00'),
    TweetData.new('tweet9', '2012-03-01T22:30:10.000+00:00'),
    TweetData.new('tweet10', '2012-03-15T13:59:10.000+00:00')
  ],
  :state5 => [
    TweetData.new('tweet2', '2012-01-01T22:30:10.000+00:00'),
    TweetData.new('tweet3', '2012-01-01T22:30:10.000+00:00'),
    TweetData.new('tweet4', '2012-01-01T22:30:10.000+00:00'),
    TweetData.new('tweet5', '2012-02-01T22:30:10.000+00:00'),
    TweetData.new('tweet6', '2012-02-01T22:30:10.000+00:00'),
    TweetData.new('tweet7', '2012-03-01T22:30:10.000+00:00'),
    TweetData.new('tweet8', '2012-03-01T22:30:10.000+00:00'),
    TweetData.new('tweet9', '2012-03-01T22:30:10.000+00:00'),
    TweetData.new('tweet10', '2012-03-15T13:59:10.000+00:00')
  ]
}

downstream_states = {
  :state1 => [
    TweetData.new('tweet1', '2012-03-01T14:30:10.000+00:00'),
    TweetData.new('tweet2', '2012-03-01T14:30:10.000+00:00'),
    TweetData.new('tweet3', '2012-03-01T14:30:10.000+00:00')
  ],
  :state2 => [
    TweetData.new('tweet1', '2012-03-01T14:30:10.000+00:00'),
    TweetData.new('tweet2', '2012-03-01T14:30:10.000+00:00'),
    TweetData.new('tweet3', '2012-03-01T14:30:10.000+00:00')
  ],
  :state3 => [
    TweetData.new('tweet1', '2012-03-01T14:30:10.000+00:00'),
    TweetData.new('tweet2', '2012-03-11T14:30:10.000+00:00'),
    TweetData.new('tweet3', '2012-03-13T14:30:10.000+00:00')
  ],
  :state4 => [
    TweetData.new('tweet1', '2011-11-01T14:30:10.000+00:00'),
    TweetData.new('tweet2', '2012-01-01T22:30:10.000+00:00'),
    TweetData.new('tweet3', '2012-01-01T22:30:10.000+00:00'),
    TweetData.new('tweet4', '2012-01-01T22:30:10.000+00:00'),
    TweetData.new('tweet5', '2012-02-01T22:30:10.000+00:00'),
    TweetData.new('tweet6', '2012-02-01T22:30:10.000+00:00'),
    TweetData.new('tweet7', '2012-03-01T22:30:10.000+00:00'),
    TweetData.new('tweet8', '2012-03-01T19:30:10.000+01:00')
  ],
  :state5 => [
    TweetData.new('tweet1', '2011-11-01T14:30:10.000+00:00'),
    TweetData.new('tweet2', '2012-01-01T22:30:10.000+00:00'),
    TweetData.new('tweet3', '2012-01-01T22:30:10.000+00:00'),
    TweetData.new('tweet4', '2012-01-01T22:30:10.000+00:00'),
    TweetData.new('tweet5', '2012-02-01T22:30:10.000+00:00'),
    TweetData.new('tweet6', '2012-02-01T22:30:10.000+00:00'),
    TweetData.new('tweet7', '2012-03-01T22:30:10.000+00:00'),
    TweetData.new('tweet8', '2012-03-01T22:30:10.000+00:00'),
    TweetData.new('tweet9', '2012-03-01T22:30:10.000+00:00'),
    TweetData.new('tweet10', '2012-03-15T13:59:10.000+00:00')
  ]
}

# TODO iterate over each hash concisely to build these state hashes.
$uncategorized_upstream_states = {
  :state1 => upstream_states[:state1].map {|d| d.diffaize(TweetDiffaizer.instance)},
  :state2 => upstream_states[:state2].map {|d| d.diffaize(TweetDiffaizer.instance)},
  :state3 => upstream_states[:state3].map {|d| d.diffaize(TweetDiffaizer.instance)},
  :state4 => upstream_states[:state4].map {|d| d.diffaize(TweetDiffaizer.instance)},
  :state5 => upstream_states[:state5].map {|d| d.diffaize(TweetDiffaizer.instance)}
}

$uncategorized_downstream_states = {
  :state1 => downstream_states[:state1].map {|d| d.diffaize(TweetDiffaizer.instance)},
  :state2 => downstream_states[:state2].map {|d| d.diffaize(TweetDiffaizer.instance)},
  :state3 => downstream_states[:state3].map {|d| d.diffaize(TweetDiffaizer.instance)},
  :state4 => downstream_states[:state4].map {|d| d.diffaize(TweetDiffaizer.instance)},
  :state5 => downstream_states[:state5].map {|d| d.diffaize(TweetDiffaizer.instance)}
}

$categorized_upstream_states = {
  :state1 => upstream_states[:state1].map {|d| d.diffaize(CategorizingTweetDiffaizer.instance)},
  :state2 => upstream_states[:state2].map {|d| d.diffaize(CategorizingTweetDiffaizer.instance)},
  :state3 => upstream_states[:state3].map {|d| d.diffaize(CategorizingTweetDiffaizer.instance)},
  :state4 => upstream_states[:state4].map {|d| d.diffaize(CategorizingTweetDiffaizer.instance)},
  :state5 => upstream_states[:state5].map {|d| d.diffaize(CategorizingTweetDiffaizer.instance)}
}

$categorized_downstream_states = {
  :state1 => downstream_states[:state1].map {|d| d.diffaize(CategorizingTweetDiffaizer.instance)},
  :state2 => downstream_states[:state2].map {|d| d.diffaize(CategorizingTweetDiffaizer.instance)},
  :state3 => downstream_states[:state3].map {|d| d.diffaize(CategorizingTweetDiffaizer.instance)},
  :state4 => downstream_states[:state4].map {|d| d.diffaize(CategorizingTweetDiffaizer.instance)},
  :state5 => downstream_states[:state5].map {|d| d.diffaize(CategorizingTweetDiffaizer.instance)}
}

post '/transition' do
  ApplicationState.instance.set params[:state]
end

get '/uncategorized/upstream/scan' do
  process_scan_request $uncategorized_upstream_states
end

get '/uncategorized/downstream/scan' do
  process_scan_request $uncategorized_downstream_states
end

get '/categorized/upstream/scan' do
  process_scan_request $categorized_upstream_states
end

get '/categorized/downstream/scan' do
  process_scan_request $categorized_downstream_states
end

$tweeted_at = Category.new('tweeted_at')

def process_scan_request(participantStates)
  filtered = filter_data(participantStates[ApplicationState.instance.get], params[$tweeted_at.param_start], params[$tweeted_at.param_end])

  # Replace this with a method that you can actually read.
  filtered = if params[$tweeted_at.param_granularity] && filtered.any? { |d| !(d[:attributes][:tweeted_at].nil?) }
      aggregate_by_tweet_time(filtered, params[$tweeted_at.param_granularity])
  else
    filtered
  end

  filtered.to_json
end

def filter_data(data, date_start, date_end)
  data.select do |datum|
    tweeted_at = datum[:attributes][:tweeted_at]
    tweet_time = Time.parse(tweeted_at) unless tweeted_at.nil?

    tweet_time.nil? || (
      (date_start.nil? || tweet_time >= Time.parse(date_start)) &&
      (date_end.nil? || tweet_time <= Time.parse(date_end))
    )
  end
end

def aggregate_by_tweet_time(data, granularity)
  bucketed = {}
  data.each do |d|
    tweeted_at = d[:attributes][:tweeted_at]
    if tweeted_at.nil?
      tweeted_at = Time.now.iso8601.to_s
    end

    bucket_name = case granularity
      when "yearly" then tweeted_at[0..3]
      when "monthly" then tweeted_at[0..6]
      when "daily" then tweeted_at[0..9]
    end

    (bucketed[bucket_name] ||= []) << d
  end

  bucketed.map do |name, entries|
    combined_version = Digest::MD5.hexdigest(entries.map { |e| e[:version] }.join(''))

    {:attributes => {:tweeted_at => name}, :version => combined_version}
  end
end

