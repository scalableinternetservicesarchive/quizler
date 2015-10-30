Quizler::Application.routes.draw do

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

  root to: 'dashboard#index'

  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :quizzes
  resources :questions
  #resources :one_player_game_flow

  resources :friends, controller: 'friendships', only: [:index, :create] do
    collection do
      get 'search'
      get 'fetch_users'
      get 'friendship_requests'
      post 'accept_friendship'
    end
  end
  #
  # get 'friends/search' => 'friendships#search_user'
  # get 'friends/fetch_users' => 'friendships#fetch_users'
  # post 'friends/create' => 'friendships#create'
  # get 'friends/friendship_requests' => 'friendships#friendship_requests'
  # post 'friends/accept_friendship' => 'friendships#accept_friendship'
  # get 'friends/' => 'friendships#index'

  get 'one_player_game_flow/ready'
  get 'one_player_game_flow/question_option'
  get 'one_player_game_flow/finale'
  get 'one_player_game_flow/score'

  get 'dashboard' => 'dashboard#fetch_questions'


end
