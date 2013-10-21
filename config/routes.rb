CyprusBooking::Application.routes.draw do
   get 'admin',  to: "admin#index" 
   get 'logout', to: "user#exit"
   match "login",to: "user#enter", via:[:post]
   match "login",to: "home#login", via:[:get]
scope "(:locale)", :locale => /en|ru/ do
   namespace :admin do
     post "login_admin"
     post "users/pass_change"
     resources :users
     resources :emails 
     resources :transactions
     resources :facilities
     resources :apartaments
     resources :characteristics
     resources :currencies
     get "apartaments",          to: "apartaments#index"
     get "apartaments/delete/:id",      to: "apartaments#delete"
     post "apartaments/upload_photos",  to: "apartaments#upload_photos"
     get "apartaments/remove_photo/:photo_id",  to: "apartaments#remove_photo"
     get "apartaments/remove_employment/:id",  to: "apartaments#remove_employment"
     get "apartaments/remove_price/:id",  to: "apartaments#remove_price"
     get "facilities",          to: "facilities#index"
     get "facilities/new",      to: "facilities#new"
     get "facilities/delete/:id",      to: "facilities#delete"
     get "currencies/delete/:id",      to: "currencies#delete"
     get "characteristics",          to: "characteristics#index"
     get "characteristics/new",      to: "characteristics#new"
     get "characteristics/delete/:id",      to: "characteristics#delete"
     get "settings", to: "settings#index"
     post "settings/save"
   end

   namespace :user do
    post "auth"
    post "forgot"
    post "register"
    post "fbregister"
   end

   namespace :cabinet do
    resources "houses", :only=>[:index,:show]
   end

  
     root :to => "home#index"
     match "apartments", to: "apartments#index", via: [:get]
     match "apartments", to: "apartments#search", via: [:post]
     post "apartments/show_index"
     get  "apartments/show/:id", to: "apartments#show"
     match "change_currency", to: "home#change_currency"

     get "apartments/complete"
   end

end
