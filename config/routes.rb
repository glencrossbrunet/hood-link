HoodLink::Application.routes.draw do
  constraints SubdomainConstraint do
    get '/' => 'organizations#dashboard'
  end
  
  root 'static#welcome'
  
  devise_for :users, skip: [:registrations, :confirmations]
end
