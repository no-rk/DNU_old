DNU::Application.routes.draw do
  devise_for :admins

  devise_for :users

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  namespace :game_data do resources :maps,   :except => [:show, :destroy] end
  namespace :game_data do resources :sups,   :except => [:show, :destroy] end
  namespace :game_data do resources :events, :except => [:show, :destroy] end

  namespace :communication do resources :messages, :only => [ :index, :new, :create, :update ] end
  namespace :communication do resources :conversations end

  namespace :register do resources :mains end
  namespace :register do resources :trades end
  namespace :register do resources :products end

  namespace :register do resources :battles end
  namespace :register do resources :duels end
  namespace :register do resources :competitions end

  namespace :register do resources :characters, :only => [ :show, :new, :create, :update ] end
  namespace :register do resources :images    , :only => [ :show, :new, :create, :update ] end
  namespace :register do resources :initials  , :only => [ :show, :new, :create, :update ] end

  namespace :register do resources :skills end
  namespace :register do resources :abilities end
  namespace :register do get 'abilities/:ability_id/new' => 'abilities#ability_id'  , :as => 'ability_id' end

  namespace :register do resources :makes, :only => [ :new, :create ] end

  get 'register' => 'register#index'  , :as => 'register_index'
  post 'history' => 'register#history', :as => 'register_history'

  get "result"                        => 'result#index',      :as => 'result'
  get "result/enos(/:new)"            => 'result#enos',       :as => 'result_enos'
  get "result/maps"                   => 'result#maps',       :as => 'result_maps'
  get "result(/:day)/eno/:id"         => 'result#eno',        :as => 'result_eno'
  get "result(/:day)/item/:id"        => 'result#item',       :as => 'result_item'
  get "result(/:day)/map/:name"       => 'result#map',        :as => 'result_map'
  get "result(/:day)/map/:name/:x/:y" => 'result#map_detail', :as => 'result_map_detail'
  get "result(/:day)/mapimage/:name"  => 'result#map_image' , :as => 'result_map_image'

  get  "gallery/:model(/:tag/tag)"   => 'gallery#index' , :as => 'gallerys'
  get  "gallery/:model/:id"          => 'gallery#show'  , :as => 'gallery'
  post "gallery/:model/:id"          => 'gallery#update'

  get  'ajax_img/:model(/:id)'  => 'ajax#img'    , :as => 'ajax_img'
  post 'ajax_html_to'           => 'ajax#html_to', :as => 'ajax_html_to'
  post 'ajax_to_html'           => 'ajax#to_html', :as => 'ajax_to_html'

  get "helps(/:name)"     => 'help#index', :as => 'helps'
  get "help/:model(/:id)" => 'help#show' , :as => 'help'

  get  "tests/parse/:type(/:text)" => 'tests#parse', :as => 'tests_parse'
  post "tests/parse/:type(/:text)" => 'tests#parse', :as => 'tests_parse'
  get  "tests/text"
  get  "tests/message"
  get  "tests/battle"
  post "tests/battle"
  get  "tests/character"
  post "tests/character"
  get  "tests/skill"
  post "tests/skill"
  get  "tests/sup"
  post "tests/sup"
  get  "tests/ability"
  post "tests/ability"
  get  "tests/effects"
  post "tests/effects"

  get "kousin"      => 'home#kousin',      :as => 'kousin'
  get "saikousin"   => 'home#saikousin',   :as => 'saikousin'
  get "kousinstate" => 'home#kousinstate', :as => 'kousinstate'

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
