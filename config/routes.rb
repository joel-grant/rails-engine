Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        get '/items', to: 'merchant_items#index'
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :items do
        get '/merchant', to: 'item_merchant#index'
      end
    end
  end
end
