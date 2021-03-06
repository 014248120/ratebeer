require 'rails_helper'

RSpec.describe Beer, type: :model do
  
  describe "with proper name and style" do
  let(:beer){ Beer.create name:"Olut", style:"fake" }

    it "is saved" do
      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end
  end

  describe "with an improper name" do
    let(:beer){ Beer.create style:"fake" }

    it "is not saved" do
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  end

  describe "with an improper style" do
    let(:beer){ Beer.create name:"Olut"}

    it "is not saved" do
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  end
end
