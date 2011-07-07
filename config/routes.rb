Expenselynx::Application.routes.draw do

  namespace :api do
    match 'user' => 'users#current', :defaults => {:format => 'json'}
    resources :receipts, :defaults => {:format => 'json'}
  end

  match "participants/search"
  match "participants/merge"
  match "participants/merge_zone"

  resources :expense_reports do
    member do
      get :download, :defaults => {:format => 'application/csv'}
    end
  end
  
  devise_for :users

  match 'stores/search'

  resources :preferences, :only => :update
  resources :dashboard, :only => :index
  resources :receipts
  resources :stores, :only => [:show, :update, :edit]
  resources :projects, :except => :destroy
  resources :participants, :except => [:new, :destroy]
  resources :expense_categories, :only => [:index, :show, :edit, :update]

  match '/preferences' => 'preferences#edit'
  root :to => "dashboard#index"
end
