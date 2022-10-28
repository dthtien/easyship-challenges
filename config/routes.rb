Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :companies, only: [] do
    resources :shipments, only: [] do
      resource :tracking, only: :show
    end
  end
end
