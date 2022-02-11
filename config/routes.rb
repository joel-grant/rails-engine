Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/merchants', to: 'merchants#index'
      get '/merchants/find', to: 'merchant_search#index'
      get '/merchants/:id', to: 'merchants#show'
      get '/merchants/:id/items', to: 'merchant_items#index'
    end
  end

  namespace :api do
    namespace :v1 do
      get '/items', to: 'items#index'
      get '/items/find_all', to: 'item_search#index'
      get '/items/new', to: 'items#new'
      post '/items', to: 'items#create'
      get '/items/:id', to: 'items#show'
      get '/items/:id/edit', to: 'items#edit'
      put '/items/:id', to: 'items#update'
      delete '/items/:id', to: 'items#delete'

      get '/items/:id/merchant', to: 'item_merchant#index'
    end
  end
end
