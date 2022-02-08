require 'rails_helper'

RSpec.describe 'api v1 merchants controller' do
  describe 'gets all merchants' do
    before(:each) do
      create_list(:merchant, 3)
      get "/api/v1/merchants"
    end

    let!(:merchants) { JSON.parse(response.body, symbolize_names: true) }
    let!(:merchant) { merchants[:data].sample(1)[0] }

    it "returns a successful response" do
      expect(response).to be_successful
    end

    it "has an array of merchants" do
      expect(merchants).to be_a(Hash)
      expect(merchants).to have_key(:data)
      expect(merchants[:data]).to be_a(Array)
      expect(merchants[:data].length).to eq(3)
    end

    it "has id, type, and attribute hash for each item" do
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq("merchant")

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a(Hash)
    end

    it "has an attribute hash with all require attributes " do
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end
end
