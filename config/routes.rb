TweetSearch::Application.routes.draw do
  get "welcome/index"
  match "/auth/:provider/callback" => "sessions#create"

  root :to => 'welcome#index'
end
