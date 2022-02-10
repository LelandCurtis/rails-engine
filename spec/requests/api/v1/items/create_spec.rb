require 'rails_helper'

RSpec.describe 'POST /api/v1/items' do
  context 'valid parameters' do
    let!(:merchant) { create(:merchant) }
    let!(:valid_parameters) { {name: 'Bob', description: 'Some description.', unit_price: 100.23, merchant_id: merchant.id} }

    before(:each) do
      post '/api/v1/items', params: valid_parameters
    end

    let!(:json) { JSON.parse(response.body, symbolize_names: true) }
    let!(:item) { Item.last }

    it "has correct 201 response" do
      expect(response).to have_http_status(201)
    end

    it "creates an item with the correct hash" do
      expect(json).to be_a(Hash)

      expect(json).to have_key(:data)
      expect(json[:data]).to be_a(Hash)


      expect(json[:data]).to have_key(:id)
      expect(json[:data][:id]).to be_a(String)

      expect(json[:data]).to have_key(:type)
      expect(json[:data][:type]).to be_a(String)
      expect(json[:data][:type]).to eq('item')

      expect(json[:data]).to have_key(:attributes)
    end

    it "creates the correct attributes" do
      expect(json[:data][:attributes]).to have_key(:name)
      expect(json[:data][:attributes][:name]).to be_a(String)
      expect(json[:data][:attributes][:name]).to eq(item.name)

      expect(json[:data][:attributes]).to have_key(:description)
      expect(json[:data][:attributes][:description]).to be_a(String)
      expect(json[:data][:attributes][:description]).to eq(item.description)

      expect(json[:data][:attributes]).to have_key(:unit_price)
      expect(json[:data][:attributes][:unit_price]).to be_a(Float)
      expect(json[:data][:attributes][:unit_price]).to eq(item.unit_price)

      expect(json[:data][:attributes]).to have_key(:merchant_id)
      expect(json[:data][:attributes][:merchant_id]).to be_a(Integer)
      expect(json[:data][:attributes][:merchant_id]).to eq(merchant.id)
    end
  end

  context 'invalid parameters' do
    let!(:merchant) { create(:merchant) }
    let!(:invalid_parameters) { {name: 'Bob', description: 'Some description.', merchant_id: merchant.id} }

    before(:each) do
      post '/api/v1/items', params: invalid_parameters
    end

    let!(:json) { JSON.parse(response.body, symbolize_names: true) }

    it "has correct 422 response and error message" do
      expect(response).to have_http_status(422)
      expect(response.body).to match(/Validation failed/)
    end
  end
end
