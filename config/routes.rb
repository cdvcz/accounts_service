CdvService::Application.routes.draw do
  resources :applications, except: [:new, :edit]

  resources :account_applications, except: [:new, :edit]
  resources :accounts, except: [:new, :edit] do
    get :authenticate, on: :collection
  end
end
