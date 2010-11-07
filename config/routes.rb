Expenselynx::Application.routes.draw do
  devise_for :users

  match 'stores/search' => 'stores#search'
  resources :dashboard
  resources :receipts
  root :to => "dashboard#index"
end
