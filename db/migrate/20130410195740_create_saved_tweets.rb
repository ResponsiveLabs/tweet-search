class CreateSavedTweets < ActiveRecord::Migration
  def change
    create_table :saved_tweets do |t|
      t.references :user_tweet
      t.string :tweet_id
      t.string :tweet_text
      t.string :profile_image_url
      t.string :user_name
      t.string :user_screen_name

      t.timestamps
    end
    add_index :saved_tweets, :user_tweet_id
  end
end
