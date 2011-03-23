Expenselynx::Application.routes.draw do
  namespace :api do
    match 'user' => 'users#current', :defaults => {:format => 'json'}
    resources :receipts, :defaults => {:format => 'json'}
  end

  match "participants/search" => 'participant#search'
  match "participants" => 'participant#index'
  match "participants/merge" => 'participant#merge'
  match "participants/merge_zone" => 'participant#merge_zone'

  resources :expense_reports do
    member do
      get :download, :defaults => {:format => 'application/csv'}
    end
  end
  devise_for :users

  match 'stores/search' => 'stores#search'
  match 'dashboard/unexpensed' => 'dashboard#unexpensed'

  resources :dashboard
  resources :receipts
  resources :stores
  resources :projects
  post "receipts/upload"
  root :to => "dashboard#index"
end
