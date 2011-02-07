Expenselynx::Application.routes.draw do
  get "projects/index"

  get "projects/show"

  get "projects/edit"

  get "projects/new"

  match "participants/search" => 'participant#search'
  match "participants" => 'participant#index'
  match "participants/merge" => 'participant#merge'
  match "participants/merge_zone" => 'participant#merge_zone'
  
  match "expense_report/:id/download" => "expense_report#download_csv"
  
  get "expense_report/:id" => "expense_report#show", :as => "expense_report"
  post "expense_report/create"
  devise_for :users

  match 'stores/search' => 'stores#search'
  match 'dashboard/unexpensed' => 'dashboard#unexpensed'
  match 'dashboard/projects'

  resources :dashboard
  resources :receipts
  resources :stores
  post "receipts/upload"
  root :to => "dashboard#index"
end
