Talkie::Application.routes.draw do
  resources :users

  resource :session, :only => [:new, :create, :destroy]

  match 'signup' => 'users#new', :as => :signup

  match 'register' => 'users#create', :as => :register

  match 'login' => 'sessions#new', :as => :login

  match 'logout' => 'sessions#destroy', :as => :logout

  match '/activate/:activation_code' => 'users#activate', :as => :activate, :activation_code => nil

  resource :dashboard do 
    
  end
  
  resource :settings, :only => [:show, :create] do 
    get :remove
  end
  
  resources :sites do 
    member do 
      get :setup
      get :settings
      get :remove
    end    
  end
  
  resources :chats do 
    
  end
  
  match '/base' => "api#base"

  root :to => 'public#index'
end
