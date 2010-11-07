Expenselynx::Application.routes.draw do
  devise_for :users

  match 'stores/search' => 'stores#search'
  resources :receipts
  root :to => "receipts#index"
end
