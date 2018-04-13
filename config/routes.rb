Rails.application.routes.draw do
  resources :people
  resources :articles
  get 'search', to: 'search#search'
  get 'quick_search', to: 'search#quick_search'
  get 'suggest/:term' => 'search#suggest'
end
