require 'rails_helper'

describe "BeermappingApi" do

  describe "in case of cache miss" do
    before :each do
      Rails.cache.clear
    end

    it "When HTTP GET returns one entry, it is parsed and returned" do
      canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>12411</id><name>Gallows Bird</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=12411</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12411&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12411&amp;d=1&amp;type=norm</blogmap><street>Merituulentie 30</street><city>Espoo</city><state></state><zip>02200</zip><country>Finland</country><phone>+358 9 412 3253</phone><overall>91.66665</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*espoo/).to_return(body: canned_answer, headers: {'Content-Type' => "text/xml"})

      places = BeermappingApi.places_in("espoo")
      
      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Gallows Bird")
      expect(place.street).to eq("Merituulentie 30")
    end
  end  

  describe "in case of cache hit" do
    it "When one entry in cache, it is returned" do
      canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>12411</id><name>Gallows Bird</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=12411</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12411&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12411&amp;d=1&amp;type=norm</blogmap><street>Merituulentie 30</street><city>Espoo</city><state></state><zip>02200</zip><country>Finland</country><phone>+358 9 412 3253</phone><overall>91.66665</overall><imagecount>0</imagecount></location></bmp_locations> 
      END_OF_STRING

      stub_request(:get, /.*espoo/).to_return(body: canned_answer, headers: {'Content-Type' => "text/xml"})

      # ensure that data found in cache
      BeermappingApi.places_in("espoo")

      places = BeermappingApi.places_in("espoo")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Gallows Bird")
      expect(place.street).to eq("Merituulentie 30")
    end
  end

  it "When HTTP GET returns one entry, it is parsed and returned" do
    
    canned_answer = <<-END_OF_STRING 
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>12411</id><name>Gallows Bird</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=12411</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12411&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12411&amp;d=1&amp;type=norm</blogmap><street>Merituulentie 30</street><city>Espoo</city><state></state><zip>02200</zip><country>Finland</country><phone>+358 9 412 3253</phone><overall>91.66665</overall><imagecount>0</imagecount></location></bmp_locations> 
    END_OF_STRING

    stub_request(:get, /.*espoo/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("espoo")

    expect(places.size).to eq(1)
    place = places.first
    expect(place.name).to eq("Gallows Bird")
    expect(place.street).to eq("Merituulentie 30")
  end

  it "When HTTP GET returns no entries, an empty array is returned" do
    
    canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*vantaa/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("vantaa")

    expect(places.size).to eq(0)
  end

  it "When HTTP GET returns multiple entries, an array of Place-objects is returned" do
    canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>10411</id><name>O'Connor's Irish Pub and Restaurant</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=10411</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=10411&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=10411&amp;d=1&amp;type=norm</blogmap><street>Stora Torget 1</street><city>Uppsala</city><state></state><zip>753 20</zip><country>Sweden</country><phone>+46-18-144010</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>10415</id><name>Williams Pub</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=10415</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=10415&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=10415&amp;d=1&amp;type=norm</blogmap><street>Åsgränd 5</street><city>Uppsala</city><state></state><zip>753 10</zip><country>Sweden</country><phone>+46-18-140920</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>11880</id><name>Pipes of Scotland</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=11880</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=11880&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=11880&amp;d=1&amp;type=norm</blogmap><street>Kungsgatan 27</street><city>Uppsala</city><state></state><zip>75321</zip><country>Sweden</country><phone>018-480 50 02</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*uppsala/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("uppsala")

    expect(places.size).to eq(3)
    place1 = places.first
    expect(place1.name).to eq("O\'Connor\'s Irish Pub and Restaurant")
    expect(place1.street).to eq("Stora Torget 1")
    place2 = places.second
    expect(place2.name).to eq("Williams Pub")
    expect(place2.street).to eq("Åsgränd 5")
  end
end
