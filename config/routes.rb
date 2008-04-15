ActionController::Routing::Routes.draw do |map|
  map.signup "/signup", :controller => "users", :action => "new"
  map.login "/login", :controller => "sessions", :action => "new"
  map.logout "/logout", :controller => "sessions", :action => "destroy"
  map.search "/search", :controller => "contents", :action => "search"
  
  map.forgot_password "/forgot_password", :controller => "passwords", :action => "new"
  map.reset_password '/reset_password/:id', :controller => "passwords", :action => "edit"

  map.resource :password  
  map.resources :options
  
  map.resources :properties do |property|
	property.resources :options, :collection => { :update_order => :post }, :member => { :set_default => :post }
  end

  map.resources :cards, :member => { :change_iteration => :post, :change_actual => :post, :change_estimated => :post } do |cards|
	cards.resources :properties, :member => { :change_option => :post }
	cards.resources :comments
  end
  
  map.resources :comments
  
  map.resources :iterations
  map.resources :team_users
  
  map.resources :teams, :member => { :edit_users => :get, :update_users => :post, :add_property => :post } do |teams|
	teams.resources :cards
	teams.resources :iterations
  end

  map.resources :pages, :collection => { :import => :get }, :member => { :edit_tags => :get, :update_tags => :post, :set_default => :post } do |pages|
    pages.resources :comments
    pages.resources :versions, :controller => :pages
  end
  
  map.resources :posts, :member => { :edit_tags => :get, :update_tags => :post } do |posts|
    posts.resources :comments
    posts.resources :versions, :controller => :posts
  end

  map.resources :blogs do |blogs|
    blogs.resources :posts
  end

  map.resources :contents, :member => { :update_tags => :put } do |contents|
    contents.resources :versions
  end

  map.resources :projects do |projects|
    projects.resources :cards, :collection => { :set_property => :post }
    projects.resources :card_types
    projects.resources :members
    projects.resources :teams
  end
  
  map.resources :cards
  map.resources :iterations
  map.resources :team_users
  
  map.resources :members
  map.resources :users
  map.resources :departments
  map.resources :tags, :member => { :edit_tags => :get }
  map.resources :links
  map.resources :attachments
  
  map.namespace :admin do |admin|
    admin.resources :projects, :member => { :update_tags => :post }
    admin.resources :cards, :member => { :set_value_for => :post }
  end
  
  map.resource :home
  map.resource :session

  map.root :controller => "homes", :action => "show"
	
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
