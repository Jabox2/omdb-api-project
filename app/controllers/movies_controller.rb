class MoviesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :search, :details, :show]
  before_action :find_movie, only: [:show, :destroy]

  def index
    @movies = current_user.movies.sort{ |x, y| x.title <=> y.title }
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
    @movie = Movie.new(movie_params)
    imdb_id_temp = @movie.imdb_id
    if current_user.movies.any?{|movie| movie.imdb_id == imdb_id_temp }
      @movie = Movie.find_by(imdb_id: imdb_id_temp)
      flash[:notice] = "You have already favorited this movie."
    elsif Movie.all.any?{|movie| movie.imdb_id == imdb_id_temp}
      @movie = Movie.find_by(imdb_id: imdb_id_temp)
      current_user.movies << @movie
      flash[:notice] = "Movie favorited."
    else
      @movie = current_user.movies.build(movie_params)
      flash[:notice] = "Movie added to database and favorited."
    end

    if current_user.save
      redirect_to @movie
    else
      flash[:alert] = "Sorry, your movie could not be saved."
      redirect_to root_path
    end
  end

  def details
    @movie = Movie.new
    url = 'http://www.omdbapi.com/?i='
    search = params[:imdb_id]
    search += '&plot=full'

    response = RestClient.get(url+search)
    @movie_info = JSON.parse(response.body)
  end

  def show
    @review = Review.new
    @edit = params[:edit]
  end

  def destroy
    if current_user.movies.delete(@movie)
      flash[:alert] = "Movie removed from your favorites."
    else
      flash[:alert] = "Failed to remove from your favorites."
    end
    
    redirect_to user_movies_path(current_user)
  end

  private
  	def find_movie
  		@movie = Movie.find(params[:id])
  	end

  	def movie_params
  		params.require(:movie).permit(:title, :year, :plot, :imdb_id)
  	end
end
