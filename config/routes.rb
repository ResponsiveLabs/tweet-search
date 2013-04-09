TweetSearch::Application.routes.draw do
  get "welcome/index"
  match "/search_tweet" => "tweet_searches#index"
  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout

  root :to => 'welcome#index'
end
