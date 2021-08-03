Rails.application.routes.draw do
  resources :posts, only: %i(show create) do
    resources :components, only: %i(create)
  end
end
