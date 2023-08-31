Rails.application.routes.draw do
  root 'homepage#index'
  get '/feeds' => 'feeds#index'

  # USERS

  post   '/users'                    => 'users#create'

  # SESSIONS

  post   '/sessions'                 => 'sessions#create'

  # TWEETS

  # Redirect all other paths to index page, which will be taken over by AngularJS
  get '*path' => 'homepage#index'
end
