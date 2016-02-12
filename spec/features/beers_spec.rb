require 'rails_helper'

describe "Beer" do

  describe "new beer" do
    before :each do
      visit new_beer_path
    end

    it "with proper name is saved" do
      fill_in('Name', with:'New')
      expect {
        click_button('Create Beer')
      }.to change{Beer.count}.from(0).to(1)
    end

    it "with improper name is not saved" do
      click_button('Create Beer')
      expect(page).to have_content 'Name can\'t be blank'
    end
  end
end
