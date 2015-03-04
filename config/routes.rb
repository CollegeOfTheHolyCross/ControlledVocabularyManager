Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  get '/ns/*id', :to => "terms#show", :as => "term"
  patch 'terms/*id', :to => "terms#update", :as => "update_term"
  patch 'vocabularies/*id', :to => "vocabularies#update", :as => "update_vocabulary"

  get '/login'  => 'login#index'
  get '/login/auth' => 'login#doauth'

  resources :vocabularies, :only => [:index, :new, :create, :edit]
  get '/vocabularies/*vocabulary_id/new', :to => "terms#new", :as => "new_term"
  resources :terms, :only => [:create, :edit]

end
