Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      namespace :items do
        get '/find', to: 'find#show'
      end

      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: :merchant_items
      end

      resources :items, only: [:index, :show, :create, :update, :destroy] do
        resources :merchant, only: [:index], controller: :item_merchants
      end


    end
  end
end
