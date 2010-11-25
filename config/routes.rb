Expenselynx::Application.routes.draw do
  get "participant/search"

  get "expense_report/:id" => "expense_report#show", :as => "expense_report"
  post "expense_report/create"
  devise_for :users

  match 'stores/search' => 'stores#search'
  match 'dashboard/unexpensed' => 'dashboard#unexpensed'
  resources :dashboard
  resources :receipts
  root :to => "dashboard#index"
end
