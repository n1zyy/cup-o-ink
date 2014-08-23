Rails.application.routes.draw do
  root "print_servers#index"

  resources :print_servers, :id => /[^\/]+/
end
