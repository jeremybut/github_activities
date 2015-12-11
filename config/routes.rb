Rails.application.routes.draw do
  root 'users#index'
  match "/search/users" => "users#search", as: :search, via: [:post, :get]
  
  resources :users, only: [:repos, :index] do 
    get 'repos', on: :member
  
    resources :repos, only: [:repo] do
      get 'details', on: :member, path: ''
    end
  
  end

  get 'clear_cache' => 'utilities#clear_cache'
end
