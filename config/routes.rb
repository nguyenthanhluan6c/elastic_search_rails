Rails.application.routes.draw do
  root to: 'home#index'
  resources :people
  resources :articles
  get 'search', to: 'search#search'
  get 'quick_search', to: 'search#quick_search'
  get 'suggest/:term' => 'search#suggest'

  get 'name/search', to: 'search_names#search', as: 'search_names'
  get 'name/misspellings/:name_term' => 'search_names#misspellings'
end
