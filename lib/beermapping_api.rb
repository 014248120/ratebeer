class BeermappingApi
  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, expires_in: 1.week) { fetch_places_in(city) }
  end

  def self.fetch_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"
    response = HTTParty.get "#{url}#{ERB::Util.url_encode (city)}"
    places = response.parsed_response["bmp_locations"]["location"]
    
    return [] if places.is_a?(Hash) and places['id'].nil? #ei löydetty baareja
    
    places = [places] if places.is_a?(Hash) #jos palautus (muuttujassa places) sisälsi vain yhden baarin
    places.map do | place |
      Place.new(place)
    end
  end

  def self.key
    raise "APIKEY env variable not defined" if ENV['APIKEY'].nil?
    ENV['APIKEY']
  end
end
