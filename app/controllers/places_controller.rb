require 'beermapping_api.rb'
class PlacesController <ApplicationController
  def index
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else 
      session[:searchedLocation] = params[:city]
      render :index
    end
  end

  def show
    placeid = params[:id]
    places = Rails.cache.read(session[:searchedLocation].downcase)
    @place = places.select{ |l| l.id = placeid }.first
  end
end
