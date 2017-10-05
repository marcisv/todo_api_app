Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :tasks, only: %i(index create update destroy)
      resources :tags, only: %i(index create update)
    end
  end

end
