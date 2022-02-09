Rails.application.routes.draw do

  # get '/api/v1/merchants/find', to: 'merchant_search#index'
  namespace :api do
    namespace :v1 do
      get '/merchants', to: 'merchants#index'
      get '/merchants/find', to: 'merchant_search#index'
      get '/merchants/:id', to: 'merchants#show'
      get '/merchants/:id/items', to: 'merchant_items#index'
    end
  end
  # namespace :api do
  #   namespace :v1 do
  #     resources :merchants, only: [:index, :show] do
  #       get '/items', to: 'merchant_items#index'
  #     end
  #   end
  # end

  namespace :api do
    namespace :v1 do
      resources :items do
        get '/merchant', to: 'item_merchant#index'
      end
    end
  end
end
