HoodLink::Application.routes.draw do
  constraints SubdomainConstraint do
    get '/' => 'organizations#dashboard'
  end
  
  resources :organizations, only: [:index]
  
  root 'static#welcome'
  
  devise_for :users, skip: [:registrations, :confirmations]
end
