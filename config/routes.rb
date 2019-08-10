Rails.application.routes.draw do
  get 'sessions/new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'users#new'

  # Ransack用
  get '/index', to: 'posts#index'

  resources :posts
  resources :comments

  # お気に入り追加・削除
  get '/likes/:id', to: 'likes#touch'

  # フォロー・アンフォロー
  get '/follow/action', to: 'follows#touch'

  # RESTfulなルーティング
  resources :users

  # ログイン機能
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

end
