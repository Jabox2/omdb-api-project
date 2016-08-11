class ReviewsController < ApplicationController
  def create
    @movie = Movie.find(params[:movie_id])
    if !( @movie.reviews.any?{|review| review.user_id.to_i == current_user.id } )
    	review = @movie.reviews.build(review_params)
    	review.user = current_user

    	if @movie.save
    		flash[:notice] = "Review created."
    	else
    		flash[:alert] = "Failed to save review."
     	end
     else
      flash[:notice] = "You already have a review for this movie."
    end
    redirect_to @movie
  end

  def edit
    review = Review.find(params[:id])
    movie = review.movie
    redirect_to movie_path(movie, edit: true)
  end

  def update
    
  end

  def destroy
    review = Review.find(params[:id])
    if review.user == current_user
      movie = review.movie
      if review.delete
       flash[:notice] = "Review deleted."
     else
       flash[:alert] = "Failed to delete review."
     end
   else
      flash[:notice] = "You are not signed in as that user."
   end

   redirect_to movie
  end

  private
  	def review_params
  		params.require(:review).permit(:body)
  	end
end
