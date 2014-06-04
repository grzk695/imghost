Rails.application.routes.draw do
 

  get 'albums/by_user'

  post "headshot/capture" => 'headshot#capture', :as => :headshot_capture
  get 'profiles/show'

  devise_for :users, :skip => [:sessions], controllers: {registrations: "users/registrations"}
  as :user do
    get 'signin' => 'devise/sessions#new', :as => :login
    post 'signin' => 'devise/sessions#create', :as => :user_session
    delete 'logout' => 'devise/sessions#destroy', :as => :logout
    get 'register' => 'users/registrations#new', :as => :register
  end

  resources :photos 
  resources :profiles
  resources :albums
  
  get '/album/add/:id/:type', to: 'albums#album_photos', :as => :add_to_album
  patch '/album/add/:id' , to: 'albums#add_photos', :as => :add_photos_to_album
  get '/a/:profile', to: 'albums#by_user', :as => :profile_albums

  match '/photos/delete/all', to: 'photos#destroy_many', via: 'delete'
  get '/camera', to: 'photos#new_camera', :as => :camera
  get '/p/:type/:id', to: 'photos#show', :as => :show_photo
  get 'photo/:id/public', to: 'photos#to_public', :as => :public_photo
  get 'photo/:id/private', to: 'photos#to_private', :as => :private_photo
  delete 'photo/:id/album', to: 'photos#delete_from_album' , :as => :delete_photo_from_album

  get '/profile/:name/all', to: 'profiles#photos', :as => :profile_photos
  

  get 'static_pages/home'
  get 'static_pages/about'
  get 'static_pages/help'
  match '/about', to: 'static_pages#about', via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'

  root 'static_pages#home'

 
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
