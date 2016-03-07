class RatingsController < ApplicationController
  before_action :ensure_that_signed_in, except: [:index, :show]
  def index
    @top_beers = Rails.cache.fetch("top_beers", expires_in:10.minutes) do Beer.top(3)  end
    @top_breweries = Rails.cache.fetch("top_breweries", expires_in:10.minutes) do Brewery.top(3)  end
    @most_active_users = Rails.cache.fetch("most_active", expires_in:10.minutes) do User.most_active(3)  end
    @ratings = Rating.all
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.create params.require(:rating).permit(:score, :beer_id)

    if @rating.save
      current_user.ratings << @rating
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end
end
