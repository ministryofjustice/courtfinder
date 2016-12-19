Courtfinder::Application.routes.draw do

  get 'admin/ping' => 'health_check#ping'
  get 'admin/healthcheck', to: 'health_check#healthcheck', as: 'healthcheck', format: :json

  # Public court pages
  # TODO: This needs tidying
  scope 'courts', :controller => :courts do
    get '/' => :index, :as => :courts
    get '/:id' => :show, :as => :court
    get '/:id/leaflets' => :information, :as => :information
    get '/:id/leaflets/defence' => :defence, :as => :defence
    get '/:id/leaflets/prosecution' => :prosecution, :as => :prosecution
    get '/:id/leaflets/juror' => :juror, :as => :juror
  end
  scope 'court-types', :controller => :court_types do
    get '/' => :index, :as => :court_types
    get '/:id' => :show, :as => :court_type
  end
  scope 'areas-of-law', :controller => :areas_of_law do
    get '/' => :index, :as => :areas_of_law
    get '/:id' => :show, :as => :area_of_law
  end
  scope 'search', :controller => :search do
    get '/' => :index, :as => :search
  end
  scope 'regions', :controller => :regions do
    get '/' => :index, :as => :regions
    get '/:id' => :show, :as => :region
  end

  get '/search/:area_of_law', to: 'home#index', as: 'area_of_law_landing'

  resources :local_authorities, only: [:index, :show]

  # Admin section
  get 'admin', to: redirect('/admin/courts')

  devise_for :users, path_prefix: 'admin'

  namespace :admin do
    resources :users
    resources :addresses
    resources :towns
    resources :counties
    resources :countries
    resources :address_types, path: '/address-types'
    # resources :postcode_court
    resources :postcodes, only: [:edit, :update] 

    resources :courts do
      collection do
        get :areas_of_law
        get :court_types
        get :civil
        get :family
        get :audit
      end
    end

    #resources :postcode_court
    #resources :postcodes, only: [:edit, :update] 

    resources :local_authorities do
      collection do
        get :complete
      end
    end

    resources :court_types

    resources :areas_of_law, path: '/areas-of-law'

    resources :area_of_law_groups, path: '/area-of-law-groups'

    resources :opening_types

    resources :contact_types

    resources :facilities

    resources :regions

    resources :areas
  end

  get '/index_area_of_law', to: redirect('/')
  get '/api' => 'home#api'

  root :to => 'home#index'

  resource :feedback
end
