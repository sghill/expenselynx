Expenselynx::Application.routes.draw do
  get "expense_report/show"

  devise_for :users

  match 'stores/search' => 'stores#search'
  match 'dashboard/unexpensed' => 'dashboard#unexpensed'
  resources :dashboard
  resources :receipts
  root :to => "dashboard#index"
end
