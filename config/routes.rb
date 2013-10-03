FumeHoods::Application.routes.draw do
  constraints SubdomainConstraint do
    get '/' => 'organizations#dashboard'
  end
  
  devise_for :users
  root 'devise/sessions#new'
end
