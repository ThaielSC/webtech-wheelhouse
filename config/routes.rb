Rails.application.routes.draw do
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
