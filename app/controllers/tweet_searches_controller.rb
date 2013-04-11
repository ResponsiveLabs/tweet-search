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

  def tweet
    @tweet = current_user.auth.status(params[:tweet_id])
    @user_tweet_saved = UserTweet.find_by_word_and_user_id(params[:active_search],current_user.id)
    @user_tweet_id = @user_tweet_saved.nil? ? 100 : @user_tweet_saved.id
    @saved_tweet = SavedTweet.new(:user_tweet_id => @user_tweet_id, :tweet_id => @tweet.id, :tweet_text => @tweet.text, 
      :profile_image_url => @tweet.profile_image_url, :user_name => @tweet.user.name, :user_screen_name => @tweet.user.screen_name ).save

    respond_to do |format|
      format.json { render json: @tweet }
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
