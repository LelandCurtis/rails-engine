require 'rails_helper'

RSpec.describe 'GET api.v1/items/:id/merchant' do
  context 'item exists' do
    let!(:merchant) { create(:merchant) }
    let!(:item) { create(:item, merchant: merchant) }

    before(:each) do
      get "/api/v1/items/#{item.id}/merchant"
    end

    let!(:json) { JSON.parse(response.body, symbolize_names: true) }

    it "returns status code 200" do
      expect(response).to have_http_status(200)
    end

    it "returns the data of the chosen item's merchant " do
      expect(json).to be_a(Hash)
      expect(json).to have_key(:data)
      expect(json[:data]).to be_a(Hash)

      expect(json[:data]).to have_key(:id)
      expect(json[:data][:id]).to be_a(String)
      expect(json[:data][:id]).to eq(merchant.id.to_s)

      expect(json[:data]).to have_key(:type)
      expect(json[:data][:type]).to eq("merchant")

      expect(json[:data]).to have_key(:attributes)
      expect(json[:data][:attributes]).to be_a(Hash)
    end

    it "returns the correct attributes in the attribute hash" do
      expect(json[:data][:attributes]).to have_key(:name)
      expect(json[:data][:attributes][:name]).to be_a(String)
      expect(json[:data][:attributes][:name]).to eq(merchant.name)
    end
  end

  context 'item does not exist' do

    before(:each) do
      get "/api/v1/items/10/merchant"
    end

    let!(:json) { JSON.parse(response.body, symbolize_names: true) }

    it "returns status code 404" do
      expect(response).to have_http_status(404)
      expect(response.body).to match(/Couldn't find Item with 'id'=10/)
    end
  end
end
