class TweetSearchesController < ApplicationController

  def index
  	@user = current_user.auth
  	@search_result = current_user.auth.search(params[:word]) unless params[:word].nil?

  	respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @search_result }
    end
  end

  def searches_saved
    @searches_saved = current_user.user_tweets
    respond_to do |format|
      format.json { render json: @searches_saved }
    end
  end

  def tweets_saved
    @search_saved = UserTweet.find_by_word_and_user_id(params[:active_search],current_user.id)
    @tweets_saved = SavedTweet.find_all_by_user_tweet_id(@search_saved.id) if @search_saved
    respond_to do |format|
    if @search_saved
      format.json { render json: @tweets_saved }
    else
      format.json { render json: { status: "1"}}
    end
  end
  end

  def tweet
    @tweet = current_user.auth.status(params[:tweet_id])
    @user_tweet_saved = UserTweet.find_by_word_and_user_id(params[:active_search],current_user.id)
    @user_tweet_id = @user_tweet_saved.nil? ? save_search(params[:active_search]).id : @user_tweet_saved.id
    @saved_tweet = SavedTweet.new(:user_tweet_id => @user_tweet_id, :tweet_id => @tweet.id, :tweet_text => @tweet.text, 
      :profile_image_url => @tweet.profile_image_url, :user_name => @tweet.user.name, :user_screen_name => @tweet.user.screen_name)

    respond_to do |format|
      if @saved_tweet.save
        format.json { render json: @saved_tweet }
      else
        format.json { render json: { status: "1"} }
      end
    end
  end

  def reply_tweet
    current_user.auth.update("#{params[:msg]}", {"in_reply_to_status_id" => params[:tweet_id]})
    render json: { reply: "ok"} 
  end

  def search
  	@search_result = current_user.auth.search(params[:word]).order('id desc')
  	render json: @search_result
  end

  def save_search(word = params[:word])
    @user_tweet = UserTweet.new(:word=>word, :user_id=>current_user.id)
    @user_tweet.save if @user_tweet.word.size > 0 && !UserTweet.find_by_word_and_user_id(params[:word],current_user.id)
    @user_tweet
  end 

  def delete_tweet
    @tweet = SavedTweet.find(params[:tweet_saved_id])
    
    respond_to do |format|
      if @tweet.delete
        format.json { render json: @tweet }
      else
        format.js {render :content_type => 'text/javascript'}
      end
    end
  end

  def delete_search
    @search_saved = UserTweet.find_by_id_and_user_id(params[:search_id],current_user.id)
    
    respond_to do |format|
      if @search_saved.delete
        SavedTweet.where(:user_tweet_id => @search_saved.id).delete_all
        format.js
      else
        format.js {render :content_type => 'text/javascript'}
      end
    end
  end


end
