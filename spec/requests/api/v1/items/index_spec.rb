require 'rails_helper'

RSpec.describe 'GET /api/v1/items' do
  context 'when items exist' do
    let!(:items) { create_list(:item, 3) }

    before(:each) do
      get "/api/v1/items"
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

  context 'when items dont exist' do

    before(:each) do
      get "/api/v1/items"
    end

    let!(:json) {JSON.parse(response.body, symbolize_names: true)}

    it "returns a status code of 200" do
      expect(response).to have_http_status(200)
    end

    it "returns the expected empty data Array" do
      expect(json).to be_a(Hash)
      expect(json).to have_key(:data)

      expect(json[:data]).to eq([])
    end
  end
end
