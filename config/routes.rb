TweetSearch::Application.routes.draw do
  resources :posts

  resources :tweets
  get "welcome/index"
  match "/search_tweet" => "tweet_searches#index"
  match "/search_tweet/save" => "tweet_searches#save_search"
  match "/search_tweet/searches_saved" => "tweet_searches#searches_saved"
  match "/search_tweet/saved_tweets" => "tweet_searches#tweets_saved"
  match "/search_tweet/tweet" => "tweet_searches#tweet"
  match "/search_tweet/tweet/delete" => "tweet_searches#delete_tweet"
  match "/search_tweet/tweet/reply" => "tweet_searches#reply_tweet"
  



  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout

  root :to => 'welcome#index'
end
