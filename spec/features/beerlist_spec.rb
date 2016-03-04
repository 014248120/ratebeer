require 'rails_helper'

describe "Beerlist page" do
    before :all do
	self.use_transactional_fixtures = false
	WebMock.disable_net_connect!(allow_localhost:true)
    end

    before :each do	
	DatabaseCleaner.strategy = :truncation
	DatabaseCleaner.start

	@brewery1 = FactoryGirl.create(:brewery, name:"Koff")
	@brewery2 = FactoryGirl.create(:brewery, name:"Schlenkerla")
	@brewery3 = FactoryGirl.create(:brewery, name:"Ayinger")
	@beer1 = FactoryGirl.create(:beer, name:"Nikolai", brewery: @brewery1, style: "Lager")
	@beer2 = FactoryGirl.create(:beer, name:"Fastenbier", brewery: @brewery2, style: "Rauchbier")
	@beer3 = FactoryGirl.create(:beer, name:"Leuchte Weisse", brewery: @brewery3, style: "Weizen")

	visit beerlist_path
    end

    after :each do
	DatabaseCleaner.clean
    end

    after :all do
	self.use_transactional_fixtures = true
    end
    
    it "shows one known beer", js:true do
	find('table').find('tr:nth-child(2)')
	expect(page).to have_content "Nikolai"
    end

    it "by default, shows beers in alphabetical order", js:true do
	expect(find('table').find('tr:nth-child(2)')).to have_content "Fastenbier"
	expect(find('table').find('tr:nth-child(3)')).to have_content "Leuchte"
	expect(find('table').find('tr:nth-child(4)')).to have_content "Nikolai"
    end

    it "when pressed style, shows beers in alphabetical order of style name", js:true do
	click_on('style')
	expect(find('table').find('tr:nth-child(2)')).to have_content "Lager"
	expect(find('table').find('tr:nth-child(3)')).to have_content "Rauchbier"
	expect(find('table').find('tr:nth-child(4)')).to have_content "Weizen"
    end

    it "when pressed brewery, shows beers in alphabetical order of brewery name", js:true do
	click_on('brewery')
	expect(find('table').find('tr:nth-child(2)')).to have_content "Ayinger"
	expect(find('table').find('tr:nth-child(3)')).to have_content "Koff"
	expect(find('table').find('tr:nth-child(4)')).to have_content "Schlenkerla"
    end

end
