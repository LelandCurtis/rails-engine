require 'rails_helper'

RSpec.describe 'GET /api/v1/items/:id' do
  context 'when item exists' do
    let!(:item) { create(:item) }

    before(:each) do
      get "/api/v1/items/#{item.id}"
    end

    let!(:json) {JSON.parse(response.body, symbolize_names: true)}

    it "returns a status code of 200" do
      expect(response).to have_http_status(200)
    end

    it "returns the expected data Hash" do
      expect(json).to be_a(Hash)
      expect(json).to have_key(:data)

      expect(json[:data]).to be_a(Hash)
    end

    it "returns the expected hash structure for the item" do
      expect(json[:data]).to be_a(Hash)

      expect(json[:data]).to have_key(:id)
      expect(json[:data][:id]).to be_a(String)

      expect(json[:data]).to have_key(:type)
      expect(json[:data][:type]).to be_a(String)
      expect(json[:data][:type]).to eq('item')

      expect(json[:data]).to have_key(:attributes)
      expect(json[:data][:attributes]).to be_a(Hash)
    end

    it "returns the expected item attributes" do
      expect(json[:data][:attributes]).to have_key(:name)
      expect(json[:data][:attributes][:name]).to be_a(String)

      expect(json[:data][:attributes]).to have_key(:description)
      expect(json[:data][:attributes][:description]).to be_a(String)

      expect(json[:data][:attributes]).to have_key(:unit_price)
      expect(json[:data][:attributes][:unit_price]).to be_a(Float)

      expect(json[:data][:attributes]).to have_key(:merchant_id)
      expect(json[:data][:attributes][:merchant_id]).to be_a(Integer)
    end
  end

  context 'when item doesnt exist' do
    it "returns a status code of 404 with error message" do
      get "/api/v1/items/12"
      expect(response).to have_http_status(404)
      expect(response.body).to match(/Couldn't find Item with 'id'=12/)
    end
  end
end
