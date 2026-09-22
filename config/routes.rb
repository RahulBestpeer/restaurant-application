Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :menu_categories, only: [ :index, :show ], param: :slug do
        member do
          get :menu_items
        end
      end

      resources :menu_items, only: [ :index, :show ]

      resources :reservations, only: [ :create, :show ], param: :confirmation_code
    end
  end
end
