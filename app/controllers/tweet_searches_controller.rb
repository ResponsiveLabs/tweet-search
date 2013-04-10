class TweetSearchesController < ApplicationController

  def index
  	@user = current_user.auth
  	@search_result = current_user.auth.search(params[:word]) unless params[:word].nil?

  	respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @search_result }
    end
  end


  def tweets_saved
    @saved_tweets = current_user.user_tweets
    respond_to do |format|
      format.json { render json: @saved_tweets }
    end
  end

  def search
  	@search_result = current_user.auth.search(params[:word]).order('id desc')
  	render json: @search_result
  end

  def save_search
    @user_tweet = UserTweet.new(:word=>params[:word], :user_id=>current_user.id)
    @user_tweet.save if @user_tweet.word.size > 0 && !UserTweet.find_by_word_and_user_id(params[:word],current_user.id)
  end 


end
