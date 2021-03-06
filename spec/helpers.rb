module Helpers
  
  def sign_in(credentials)
    visit signin_path
    fill_in('username', with:credentials[:username])
    fill_in('password', with:credentials[:password])
    click_button('Log in')
  end

  def rate_a_beer()
    visit new_rating_path
    select('Iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')
    click_button('Create Rating')
  end

  def create_beer_with_rating(user, score, stylevar="Lager", breweryvar=brewery)
    beer = FactoryGirl.create(:beer, brewery:breweryvar, style:stylevar)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end

  def create_beers_with_ratings(user, *scores)
    scores.each do |score|
      create_beer_with_rating(user, score )
    end
  end
end
