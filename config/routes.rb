require 'api_constraints'
Rails.application.routes.draw do
  constraints(:subdomain => /\b(api|devapi)\b/) do
    namespace :api, defaults: { format: "json" }, :path => '/' do
      scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
          root 'home#welcome'
          resources :users 
          resources :sessions do
            collection do
              get :signup_form
              post :signup
              post :login
            end           
          end
          resources :flictunes do
              collection do
                post :create_flictune
              end
              member do
                get :meta
                get :music
                get :photos
                patch :set_metadata
                patch :set_music
              end
              resources :photos do
                collection do
                  post :add_photo
                  post :photo_order
                end

              end
            end
          #devise_for :users, :controllers => { :omniauth_callbacks => "api/v1/users/omniauth_callbacks",:sessions => "api/v1/users/sessions"}
          resources :photos
      end
  end
 end
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"


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
