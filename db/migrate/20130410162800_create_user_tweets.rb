class CreateUserTweets < ActiveRecord::Migration
  def change
    create_table :user_tweets do |t|
      t.references :user
      t.string :word

      t.timestamps
    end
    add_index :user_tweets, :user_id
  end
end
