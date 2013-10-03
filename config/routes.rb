FumeHoods::Application.routes.draw do
  devise_for :users
  root 'application#home'
end
