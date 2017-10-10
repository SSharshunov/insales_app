InsalesApp::Application.routes.draw do
  #esources :deliveries
  root to: 'main#index'

  resource  :session do
    collection do
      get :autologin
    end
  end

  get '/install',   to: 'insales_app#install',   as: :install
  get '/uninstall', to: 'insales_app#uninstall', as: :uninstall
  get '/login',     to: 'sessions#new',          as: :login
  get '/main',      to: 'main#edit',            as: :main
  post '/main',     to: 'main#update'

  get '/update',    to: "main#update",           as: :update
  get '/install_delivery', to: "main#install_delivery_variant", as: :dinstall
  get '/delete_delivery',  to: "main#delete_delivery_variant"

  get ':controller/:action/:id'
  get ':controller/:action/:id.:format'

  get '/deliveries_standart', to: 'deliveries#calc_standart', as: 'deliveries_standart'
  get '/deliveries_express',  to: 'deliveries#calc_express',  as: 'deliveries_express'

  get "deliveries/:service/id/:insales_id", to: "deliveries#calc"



  get    '/main/new(.:format)',   to: 'main#new',  as: :new_account
  get    '/main/edit(.:format)',  to: 'main#edit', as: :edit_account
  get    '/main(.:format)',       to: 'main#show', as: :account
  patch  '/main(.:format)',       to: 'main#update'
  put    '/main(.:format)',       to: 'main#update'
  #delete '/main(.:format)',       to: 'main#destroy'
  #post   '/main(.:format)',       to: 'main#create'


end
