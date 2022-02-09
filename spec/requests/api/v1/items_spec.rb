require 'rails_helper'

RSpec.describe 'items api requests' do
  describe 'GET /api/v1/items' do
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

  describe 'GET /api/v1/items/:id' do
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

  describe 'POST /api/v1/items' do
    context 'valid parameters' do
      let!(:merchant) { create(:merchant) }
      let!(:valid_parameters) { {name: 'Bob', description: 'Some description.', unit_price: 100.23, merchant_id: merchant.id} }

      before(:each) do
        post '/api/v1/items', params: valid_parameters
      end

      let!(:json) { JSON.parse(response.body, symbolize_names: true) }
      let!(:item) { Item.last }

      it "has correct 200 response" do
        expect(response).to have_http_status(200)
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

  end
end
