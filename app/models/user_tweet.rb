class UserTweet < ActiveRecord::Base
  attr_accessible :user_id, :word
  before_save :downcase_word
  belongs_to :user

  def downcase_word
  	self.word = self.word.downcase
  end
end
