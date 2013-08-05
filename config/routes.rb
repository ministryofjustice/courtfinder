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

  # stubbing an HTML API
  namespace :api do
    scope 'courts', :controller => :courts do
      match '/:id' => :show
    end
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

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
