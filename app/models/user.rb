class User < ActiveRecord::Base
  attr_accessible :name, :uid, :oauth_token ,:oauth_token_secret

  def self.create_with_omniauth(auth)
    create! do |user|
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.oauth_token = auth["credentials"]["token"]
      user.oauth_token_secret = auth["credentials"]["token"] 
    end
  end
end
