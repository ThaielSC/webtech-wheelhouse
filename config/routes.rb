Rails.application.routes.draw do
  root "pages#home"

  get "visiting-the-workshop", to: "pages#workshop", as: :workshop
  get "about", to: "pages#about", as: :about

  resources :customers
  resources :bikes
  resources :repairs
  resources :services
  resources :staff_members

  get "up" => "rails/health#show", as: :rails_health_check
end
