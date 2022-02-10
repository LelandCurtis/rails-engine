require 'rails_helper'

RSpec.describe 'PATCH /api/v1/items/:id' do
  context 'valid parameters' do
    let!(:merchant) { create(:merchant) }
    let!(:item)  { create(:item) }
    let!(:valid_attributes) { {name: 'Steve', description: 'Hi Hi', unit_price: 100.3, merchant_id: merchant.id} }

    before(:each) do
      patch "/api/v1/items/#{item.id}", params: valid_attributes
    end

    let!(:json) { JSON.parse(response.body, symbolize_names: true) }

    it "returns a status code 200" do
      expect(response).to have_http_status(200)
    end

    it "creates an item with the correct hash" do
      item.reload
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
      item.reload
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

    it "updated the model" do
      updated_item = Item.last
      expect(updated_item.name).to eq(valid_attributes[:name])
      expect(updated_item.description).to eq(valid_attributes[:description])
      expect(updated_item.unit_price).to eq(valid_attributes[:unit_price])
      expect(updated_item.merchant_id).to eq(valid_attributes[:merchant_id])
    end
  end

  context 'invalid parameters - bad price' do
    let!(:merchant) { create(:merchant) }
    let!(:item)  { create(:item, name: 'Joe') }
    let!(:invalid_attributes) { {name: 'Al', unit_price: "asjb", merchant_id: merchant.id} }

    before(:each) do
      patch "/api/v1/items/#{item.id}", params: invalid_attributes
    end

    it "returns a status code 404 and expected error response message" do
      expect(response).to have_http_status(404)
      expect(response.body).to match(/Unit price is not a number/)
    end

    it "didn't update the model" do
      updated_item = Item.last
      expect(updated_item.name).to_not eq(invalid_attributes[:name])
      expect(updated_item.merchant_id).to_not eq(invalid_attributes[:merchant_id])
    end
  end

  context 'invalid parameters - bad merchant id' do
    let!(:item)  { create(:item, name: 'Joe') }
    let!(:invalid_attributes) { {name: 'Al',  merchant_id: 24} }

    before(:each) do
      patch "/api/v1/items/#{item.id}", params: invalid_attributes
    end

    it "returns a status code 404 and expected error response message" do
      expect(response).to have_http_status(404)
      expect(response.body).to match(/Merchant must exist/)
    end

    it "didn't update the model" do
      updated_item = Item.last
      expect(updated_item.name).to_not eq(invalid_attributes[:name])
      expect(updated_item.merchant_id).to_not eq(invalid_attributes[:merchant_id])
    end
  end

  context 'item doesnt exist' do
    let!(:merchant) { create(:merchant) }
    let!(:valid_attributes) { {name: 'Steve', description: 'Hi Hi', unit_price: 100.3, merchant_id: merchant.id} }

    before(:each) do
      patch "/api/v1/items/43", params: valid_attributes
    end

    it "returns a status code 404 and expected error response message" do
      expect(response).to have_http_status(404)
      expect(response.body).to match(/Couldn't find Item with 'id'=43/)
    end
  end
end
