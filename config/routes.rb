Expenselynx::Application.routes.draw do
  match "participants/search" => 'participant#search'
  
  #UNTESTED SPIKE
  get "expense_report/download_csv/:id" => "expense_report#download_csv"
  #END UNTESTED SPIKE
  
  get "expense_report/:id" => "expense_report#show", :as => "expense_report"
  post "expense_report/create"
  devise_for :users

  match 'stores/search' => 'stores#search'
  match 'dashboard/unexpensed' => 'dashboard#unexpensed'
  resources :dashboard
  resources :receipts
  resources :stores
  post "receipts/upload"
  root :to => "dashboard#index"
end
