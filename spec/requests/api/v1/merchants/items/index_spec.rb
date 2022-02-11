require 'rails_helper'

RSpec.describe 'GET /merchants/:merchant_id/items' do
  context 'when items exist' do
    let!(:merchant) { create(:merchant) }
    let!(:items) { create_list(:item, 3, merchant: merchant)}

    before(:each) do
      get "/api/v1/merchants/#{merchant.id}/items"
    end

    let!(:json) {JSON.parse(response.body, symbolize_names: true)}
    let!(:item) { json[:data].sample(1)[0] }

    it "returns a status code of 200" do
      expect(response).to have_http_status(200)
    end

    it "returns the expected data Array with 3 objects" do
      expect(json).to be_a(Hash)
      expect(json).to have_key(:data)

      expect(json[:data]).to be_a(Array)
      expect(json[:data].length).to eq(3)
    end

    it "returns the expect hash structure for each item" do
      expect(item).to be_a(Hash)

      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to be_a(String)
      expect(item[:type]).to eq('item')

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)
    end

    it "returns the expected item attributes" do
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
    end
  end

  context 'when items dont exist but merchant does' do
    let!(:merchant) { create(:merchant) }

    before(:each) do
      get "/api/v1/merchants/#{merchant.id}/items"
    end

    let!(:json) {JSON.parse(response.body, symbolize_names: true)}

    it "returns a status code of 404" do
      expect(response).to have_http_status(404)
    end

    it "returns a hash with message and errors keys" do
      expect(json).to be_a(Hash)
      expect(json).to have_key(:message)

      expect(json[:message]).to eq('Your query could not be completed')
    end

    it "returns an errors array" do
      expect(json).to have_key(:errors)
      expect(json[:errors]).to be_a(Array)
      expect(json[:errors][0]).to match(/Merchant has no items/)
    end
  end

  context 'when merchant doesnt exist' do

    before(:each) do
      get "/api/v1/merchants/19/items"
    end

    let!(:json) {JSON.parse(response.body, symbolize_names: true)}

    it "returns a status code of 404 with error message" do
      expect(response).to have_http_status(404)
      expect(response.body).to match(/Couldn't find Merchant with 'id'=19/)
    end
  end
end
