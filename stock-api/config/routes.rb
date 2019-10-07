Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
    resources :portfolios
    resources :transactions
    collection do
      post '/login', to: 'users#login'
      post '/current_user', to: 'users#show'
    end
  end
  resources :transactions
  resources :portfolios do
    get '/update_portfolio', to: 'portfolio#get_updated_portfolio'
  end

end
