HoodLink::Application.routes.draw do
  constraints SubdomainConstraint do
    get '/' => 'organizations#dashboard'
    
    resources :roles, only: [:index, :create, :destroy], 
        constraints: { id: /[^\/]+(?=\.json\z)|[^\/]+/ }
  end
  
  resources :organizations, only: [:index]
  
  root 'static#welcome'
  
  devise_for :users, skip: [:registrations, :confirmations]
end
