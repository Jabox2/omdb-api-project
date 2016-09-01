class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user_page

  private
  def authenticate_user_page
  	if params[:user_id] != nil && params[:user_id].to_i != current_user.id
		flash[:alert] = "You are not signed in as that user!"
		redirect_to root_path
	end
  end
end