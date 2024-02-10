# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }

  namespace :users do
    resources :auctions, only: %i[create show index destroy] do
      member do
        post :finish
        post :update
      end
    end
    resources :bids, only: %i[index]
  end

  resources :auctions, only: %i[index show] do
    resources :bids, only: %i[index create], controller: 'auctions/bids'
    resources :members, only: %i[index], controller: 'auctions/members'
  end

  resources :users, only: [] do
    collection do
      get :info
      put :replenish
      put :update
    end
  end
end
