class TweetSearchesController < ApplicationController

  def index
  	@user = current_user.auth
  end

  def search
  	@search_result = @user.current_user.auth.search(params[:word])
  end
end
