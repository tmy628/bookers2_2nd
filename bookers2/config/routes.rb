Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'

  resources :homes, only: [:new, :cerate, :show]

  resources :books

  resources :users

  get 'home/about' => 'homes#show', as: 'about'
end
