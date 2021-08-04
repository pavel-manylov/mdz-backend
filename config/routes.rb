Rails.application.routes.draw do
  resources :posts, only: %i(show create update) do
    resources :components, only: %i(index show create update destroy)
  end
end
