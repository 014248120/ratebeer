require 'rails_helper'

include Helpers

RSpec.describe User, type: :model do

  let(:brewery){ FactoryGirl.create(:brewery) }

  it "has the username set correctly" do
    user=User.new username:"Pekka"

    expect(user.username).to eq ("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      rating = FactoryGirl.create(:rating)
      rating2 = FactoryGirl.create(:rating2)

      user.ratings << rating
      user.ratings << rating2

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "with an improper password" do
    let(:user){ User.create username:"Pekka", password:"Secret", password_confirmation:"Secret" }

    it "is not saved" do
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer);
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(user, 10)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with the highest rating if several rated" do
      create_beers_with_ratings(user, 10, 20, 15)
      best = create_beer_with_rating(user, 30)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryGirl.create(:user) }
    
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one style rated" do
      create_beers_with_ratings(user, 10, 20) #create Lager-beers

      expect(user.favorite_style).to eq("Lager")
    end

    it "is the one with the highest ratings if several rated" do
      create_beers_with_ratings(user, 5, 5, 10) #create Lager-beers
      best = create_beer_with_rating(user, 40, "Pilsner") #create a Pilsner-beer

      expect(user.favorite_style).to eq(best.style)
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryGirl.create(:user) }

    it "has a method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated if only one brewery rated" do
      create_beers_with_ratings(user, 10, 20) #create anonymous-beers

      expect(user.favorite_brewery).to eq(brewery)
    end

    it "is the one with the highest ratings if several rated" do
      brewery2 = FactoryGirl.create(:brewery, name:"Poliisi", year:2000)
      create_beers_with_ratings(user, 10, 5) #create anonymous-beers
      create_beer_with_rating(user, 30, "Lager", brewery2) #create beer with different brewery and better rating

      expect(user.favorite_brewery).to eq(brewery2)
    end
  end

end
