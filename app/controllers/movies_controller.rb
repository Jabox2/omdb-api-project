class MoviesController < ApplicationController
  before_action :find_movie, only: [:show, :destroy]

  def index
  end

  def search
    @movie = Movie.new
    session[:return_to] ||= request.referer
    url = 'http://www.omdbapi.com/?s='
    search = params[:q]

    response = RestClient.get(url+search)

    data = JSON.parse(response.body)
    @results = data['Search']

    if @results
      render :results
    else flash[:alert] = "No results for #{search}."
      redirect_to welcome_path
    end
  end

  def create
  end

  def show
  end

  def destroy
  end

  private
  	def find_movie
  		@movie = Movie.find(params[:id])
  	end

  	def movie_params
  		params.require(:movie).permit(:title, :year)
  	end
end
