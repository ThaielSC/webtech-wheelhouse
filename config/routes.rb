Rails.application.routes.draw do
  resource :session
  resource :registration, only: %i[new create]
  resources :passwords, param: :token

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :services, only: [ :index, :show, :create ]
      resources :repairs, only: [ :index, :show ]
      match "(*path)", to: "base#not_found", via: :all
    end
  end

  root "pages#home"

  get "visiting-the-workshop", to: "pages#workshop", as: :workshop
  get "about", to: "pages#about", as: :about

  resources :customers
  resources :bikes
  resources :repairs do
    delete "intake_photos/:attachment_id", to: "repairs#destroy_photo", as: :intake_photo, on: :member
  end
  resources :services
  resources :staff_members

  get "up" => "rails/health#show", as: :rails_health_check
end
