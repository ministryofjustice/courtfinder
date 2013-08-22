Courtfinder::Application.routes.draw do

  # Public court pages
  scope 'courts', :controller => :courts do
    match '/' => :index, :as => :courts
    match '/:id' => :show, :as => :court
    match '/:id/leaflets' => :information, :as => :information
    match '/:id/leaflets/defence' => :defence, :as => :defence
    match '/:id/leaflets/prosecution' => :prosecution, :as => :prosecution
  end
  scope 'court-types', :controller => :court_types do
    match '/' => :index, :as => :court_types
    match '/:id' => :show, :as => :court_type
  end
  scope 'areas-of-law', :controller => :areas_of_law do
    match '/' => :index, :as => :areas_of_law
    match '/:id' => :show, :as => :area_of_law
  end
  scope 'search', :controller => :search do
    match '/' => :index, :as => :search
  end
  scope 'regions', :controller => :regions do
    match '/' => :index, :as => :regions
    match '/:id' => :show, :as => :region
  end
  
  # Admin section
  get 'admin', to: redirect('/admin/courts')

  devise_for :users, :path_prefix => 'admin'

  namespace :admin do
    resources :users

    resources :addresses

    resources :towns

    resources :counties

    resources :countries

    resources :address_types, :path => '/address-types'

    resources :courts

    resources :court_types

    resources :areas_of_law, :path => '/areas-of-law'

    resources :opening_types

    resources :contact_types

    resources :facilities

    resources :regions

    resources :areas
  end
  root :to => 'home#index'
end
