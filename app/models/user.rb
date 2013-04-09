class User < ActiveRecord::Base
  attr_accessible :name, :uid, :oauth_token ,:oauth_token_secret

  def self.create_with_omniauth(auth)
    create! do |user|
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.oauth_token = auth["credentials"]["token"]
      user.oauth_token_secret = auth["credentials"]["secret"] 
    end
  end

  def auth
  	Twitter::Client.new(
  		:oauth_token => self.oauth_token,
  		:oauth_token_secret => self.oauth_token_secret
	)
  end
end
