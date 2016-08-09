Rails.application.routes.draw do
  get 'movies/index'

  get 'movies/show'

	root 'welcome#index'
	get 'welcome/index'
	get 'welcome' => 'welcome#index'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
