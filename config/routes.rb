Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  get "/api-docs/v1/swagger.yaml", to: "api_docs#spec"

  get "up" => "rails/health#show", as: :rails_health_check

  # Payment provider webhooks
  post "/webhooks/:provider", to: "webhooks#create"

  namespace :api do
    namespace :v1 do
      resources :menu_categories, only: [ :index, :show ], param: :slug

      resources :menu_items, only: [ :index, :show ]

      resources :reservations, only: [ :index, :create, :show, :update ], param: :confirmation_code do
        member do
          delete :cancel
        end
      end

      # POST /api/v1/reservations/:confirmation_code/payment
      post "reservations/:confirmation_code/payment", to: "payments#create", as: :reservation_payment
      get "reservations/:confirmation_code/payment", to: "payments#show", as: :show_reservation_payment

      resources :tables, only: [ :index ] do
        collection do
          get :available
        end
      end

      resources :events, only: [ :index, :show ]

      resources :gallery, only: [ :index, :show ], controller: "gallery_items"
      resources :team_members, only: [ :index, :show ]

      resources :business_hours, only: [ :index ] do
        collection do
          get :availability
        end
      end
    end
  end
end
