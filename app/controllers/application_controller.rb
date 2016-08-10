class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
#  before_action :authenticate_user_page
#
#  private
#  def authenticate_user_page
#  	if params[:user_id] != 
#  end
end