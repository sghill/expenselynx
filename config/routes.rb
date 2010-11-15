Expenselynx::Application.routes.draw do
  devise_for :users

  match 'stores/search' => 'stores#search'
  match 'dashboard/unexpensed' => 'dashboard#unexpensed'
  resources :dashboard
  resources :receipts
  resources :expense_report
  root :to => "dashboard#index"
end
