Rails.application.routes.draw do
	devise_for :users
	root 'welcome#index'

	get 'welcome' => 'welcome#index'

	resources :movies, only: [:index, :show]
	get 'search' => 'movies#search'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
