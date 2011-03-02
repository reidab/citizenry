Citizenry::Application.routes.draw do 
  root :to => "site#index"

  resources :authentications
  resources :companies do
    resources :employees, :controller => :employments, :only => [:new, :create]
    member do
      post 'join'
      post 'leave'
    end
  end
  resources :groups do
    member do
      post 'join'
      post 'leave'
    end
  end
  resources :people do
    member do
      get 'claim'
      get 'photo'
    end
  end
  resources :projects do
    member do
      post 'join'
      post 'leave'
    end
  end
  resources :resources
  resources :users, :only => [:show, :index, :destroy] do
    member do
      post 'adminify'
    end
  end
  get '/welcome' => 'users#welcome', :as => 'welcome_users'
  get '/home' => 'users#home', :as => 'home_users'

  resources :user_sessions, :only => [:new], :controller => 'users/sessions'

  devise_for :users do
    get "/sign_out" => "devise/sessions#destroy"
    get "/sign_in" => "users/sessions#new"
  end

  match '/auth/:provider/callback' => 'authentications#create'
  match '/auth/auto' => 'authentications#auto'
  match '/route_login' => 'authentications#route_login', :as => 'login_router'

  resources :changes, :controller => 'paper_trail_manager/changes'

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
