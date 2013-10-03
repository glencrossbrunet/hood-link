FumeHoods::Application.routes.draw do
  constraints SubdomainConstraint do
    get '/' => 'organizations#dashboard'
  end
  
  devise_for :users, skip: [:registrations] 
  
  devise_scope :user do
    root 'devise/sessions#new'
  end
end
