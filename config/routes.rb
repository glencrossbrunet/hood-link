HoodLink::Application.routes.draw do
  constraints SubdomainConstraint do
    get '/' => 'organizations#dashboard'
    
    resources :roles, only: [:index, :create, :update, :destroy], 
        constraints: { id: /[^\/]+(?=\.json\z)|[^\/]+/ }
    
    resources :filters, only: [:index, :create, :update, :destroy]
    
    resources :fume_hoods, only: [:index, :create, :update] do
			member do
				get 'display'
        get 'samples'
			end
      collection do
        post 'upload'
      end
		end
    
    resources :samples, only: [:index, :create]
  end
  
  resources :organizations, only: [:index]
  
  root 'static#welcome'
  
  devise_for :users, skip: [:registrations, :confirmations]
  
  mount Resque::Server, at: '/resque'
end
