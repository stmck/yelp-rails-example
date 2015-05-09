Rails.application.routes.draw do
  root 'home#index', as: :home_index

  devise_for :users, 
  path_names: { sign_in: "login", sign_out: "logout"}, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  
  get 'sign/index'
  get 'sign/show'

  #get 'home/index'

  #mypageに、お気に入りにした店を表示するgetメソッド
  #mypageに、お気に入りにした店のパラムスデータをとばすpostメソッド
  #mypageに、お気に入りにした店を、  消すdestroyメソッド。deleteメソッド
  get 'mypage', to: 'favorite#index', as: :favorite_index
  post 'mypage', to: 'favorite#create', as: :favorite_create
  delete 'mypage/:id', to: 'favorite#destroy', as: :favorite_destroy

  # post 'favorite/create'

  post '/search' => 'home#search'


  get '/auth/:provider/callback',    to: 'users#create',       as: :auth_callback
  get '/auth/failure',               to: 'users#auth_failure', as: :auth_failure

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
