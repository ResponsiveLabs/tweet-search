class SavedTweet < ActiveRecord::Base
  belongs_to :user_tweet
  attr_accessible :profile_image_url, :tweet_id, :tweet_text, :user_name, :user_screen_name, :user_tweet_id

  validates_uniqueness_of :tweet_id, :scope => :user_tweet_id
end
