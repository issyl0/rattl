Rattl::Application.routes.draw do
  resources :user_details
  resources :skills
  get '/job_search', to: 'job_search#index'
  post '/job_search', to: 'job_search#create'
  get '/job_search/create', to: 'job_search#search'
  get '/job_search/list', to: 'job_search#list'
  get '/job_result/verdict', to: 'job_result#verdict'
  get '/job_result/success', to: 'job_result#success'
  get '/job_result/failure', to: 'job_result#failure'

  devise_for :users, :controllers => { :registrations => "users/registrations", :omniauth_callbacks => "users/omniauth_callbacks" }
  root 'welcome#welcome'
end
