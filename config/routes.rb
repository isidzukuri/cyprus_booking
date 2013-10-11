CyprusBooking::Application.routes.draw do
   get 'admin',  to: "admin#index" 
   get 'logout', to: "user#exit"
   post 'login', to: "user#enter"
   match "details",to:"home#details" , :via=>:post
   match "check_details" , to: "home#check_details"


   namespace :admin do
     post "login_admin"
     post "users/pass_change"
     resources :users
     resources :emails 
     resources :transactions
     resources :facilities
     resources :apartaments
     get "apartaments",          to: "apartaments#index"
     get "apartaments/delete/:id",      to: "apartaments#delete"
     get "apartaments/remove_photo/:photo_id",  to: "apartaments#remove_photo"
     get "facilities",          to: "facilities#index"
     get "facilities/new",      to: "facilities#new"
     get "facilities/delete/:id",      to: "facilities#delete"
     get "settings", to: "settings#index"
     post "settings/save"
   end

   namespace :user do
    post "auth"
    post "forgot"
   end


   root :to => "home#index"

   match "apartments", to: "home#apartments", via: [:get]

end
