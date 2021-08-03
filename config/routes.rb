Rails.application.routes.draw do
  resources :posts, only: %i(create) do
    resources :components, only: %i(create)
  end
end
