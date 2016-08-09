Rails.application.routes.draw do
	devise_for :users
	root 'welcome#index'

	get 'welcome' => 'welcome#index'

	resources :users, only: [:show] do
		resources :movies, only: [:index, :show, :create, :destroy]
		post 'favorite' => 'movies#favorite'
	end

	get 'search' => 'movies#search'
	get 'details/:imdb_id' => 'movies#details', as: 'details'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
