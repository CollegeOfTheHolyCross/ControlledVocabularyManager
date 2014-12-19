Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'


 
  get '/vocabs', :to => "controlled_vocabularies#index", :as => "controlled_vocabularies"
  get '/login'  => 'login#doauth'
  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  get '/ns/*id', :to => "controlled_vocabularies#show", :as => "controlled_vocabulary"

  resources :vocabularies, :only => [:new, :create]


end
