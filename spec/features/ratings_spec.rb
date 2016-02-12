require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"Iso 3", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('Iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)
    
    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  describe "when user has a rating" do
    
    it "is shown on the raters user page" do
      beer3 = create_beer_with_rating(user, 20, "Lager", brewery)
      visit user_path(user)

      expect(page).to have_content 'List of ratings'
      expect(page).to have_content "#{beer3.name} 20"
    end

    it "is listed on ratings index page" do
      beer3 = create_beer_with_rating(user, 20, "Lager", brewery)
      visit ratings_path

      expect(page).to have_content "#{beer3.name} 20"
      expect(page).to have_content 'Number of ratings: 1'
    end

    it "is destroyed when user deletes it" do
      beer3 = create_beer_with_rating(user, 20, "Lager", brewery)
      visit user_path(user)

      expect{
        click_link('delete')
      }.to change{Rating.count}.from(1).to(0)
    end
  end
end
