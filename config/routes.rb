Expenselynx::Application.routes.draw do
  namespace :api do
    match 'user' => 'users#current', :defaults => {:format => 'json'}
    resources :receipts, :defaults => {:format => 'json'}
  end

  match "participants/search" => 'participants#search'
  match "participants/merge" => 'participants#merge'
  match "participants/merge_zone" => 'participants#merge_zone'

  resources :expense_reports do
    member do
      get :download, :defaults => {:format => 'application/csv'}
    end
  end
  devise_for :users

  match 'stores/search' => 'stores#search'
  match 'dashboard/unexpensed' => 'dashboard#unexpensed'
  
  resources :participants
  resources :dashboard
  resources :receipts
  resources :stores
  resources :projects
  post "receipts/upload"
  root :to => "dashboard#index"
end
