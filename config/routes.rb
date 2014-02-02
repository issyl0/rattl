Rattl::Application.routes.draw do
  resources :user_details
  resources :skills
  devise_for :users, :controllers => { :registrations => "users/registrations", :omniauth_callbacks => "users/omniauth_callbacks" }
  root 'welcome#index'
end
