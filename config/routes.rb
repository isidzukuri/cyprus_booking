Dai::Application.routes.draw do
   get 'admin',  to: "admin#index" 
   get 'logout', to: "user#exit"
   post 'login', to: "user#enter"
   match "details",to:"home#details" , :via=>:post
   match "check_details" , to: "home#check_details"
   match "payment_success" , to: "home#payment_success"
   post "pay", to: "home#pay"
   get "home/index"
   namespace :admin do
     post "login_admin"
     post "users/pass_change"
     resources :users
     resources :emails 
     resources :penalties
     resources :transactions
     get "articles",          to: "articles#index"
     get "articles/regions",  to: "articles#regions"
     get "articles/get_form/:id", to: "articles#get_form"
     get "articles/delete_dic/:id", to: "articles#delete_dic"
     match "articles/save_item", to: "articles#save_item" ,:via=>[:post,:put]
     match "articles/save_detail", to: "articles#save_detail" ,:via=>[:post,:put]
     get "articles/banks" ,   to: "articles#banks"
     get "articles/new",      to: "articles#new"
     get "articles/edit/:id", to: "articles#edit"
     post "articles/create",  to: "articles#create"
     post "articles/update",  to: "articles#update"
     get "settings", to: "settings#index"
     post "settings/save"
   end
get  "user/penalties/:id" => "user#show_penalty"

   namespace :user do
    get  "penalties"
    put  "pay_penalty" 
    post "auth"
    post "forgot"
   end


   root :to => "home#index"
   get "home/details"

   post "create/penalty" , to: "home#create_penalty"

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
