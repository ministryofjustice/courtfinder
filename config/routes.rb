Courtfinder::Application.routes.draw do

  # Public court pages
  # TODO: This needs tidying
  scope 'courts', :controller => :courts do
    match '/' => :index, :as => :courts
    match '/:id' => :show, :as => :court
    match '/:id/leaflets' => :information, :as => :information
    match '/:id/leaflets/defence' => :defence, :as => :defence
    match '/:id/leaflets/prosecution' => :prosecution, :as => :prosecution
    match '/:id/leaflets/juror' => :juror, :as => :juror
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
  scope 'postcodes', :controller => :postcodes do
    match '/repossession' => :repossession, :as => :repossession
  end

  resources :councils, only: [:index, :show]

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

    resources :courts do
      collection do
        get :areas_of_law
        get :court_types
        get :postcodes
        get :family
        get :audit
      end
    end

    resources :councils do
      collection do
        get :complete
      end
    end

    resources :court_types

    resources :areas_of_law, :path => '/areas-of-law'

    resources :opening_types

    resources :contact_types

    resources :facilities

    resources :regions

    resources :areas
  end
  
  get '/api' => 'home#api'

  root :to => 'home#index'

  resource :feedback
end
