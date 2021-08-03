Rails.application.routes.draw do
  resources :posts, only: %i(show create) do
    resources :components, only: %i(index create update)
  end
end
