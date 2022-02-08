require 'rails_helper'

RSpec.describe 'api v1 merchants controller' do
  describe 'GET /merchants' do
    context 'when there are merchants' do
      before(:each) do
        create_list(:merchant, 3)
        get "/api/v1/merchants"
      end

      let!(:merchants) { JSON.parse(response.body, symbolize_names: true) }
      let!(:merchant) { merchants[:data].sample(1)[0] }

      it "returns a successful response" do
        expect(response).to have_http_status(200)
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

    context 'when there are no merchants' do
      before(:each) do
        get "/api/v1/merchants"
      end

      let!(:merchants) { JSON.parse(response.body, symbolize_names: true) }

      it "returns a successful response" do
        expect(response).to have_http_status(200)
      end

      it "has an empty array of merchants" do
        expect(merchants).to be_a(Hash)
        expect(merchants).to have_key(:data)
        expect(merchants[:data]).to be_a(Array)
        expect(merchants[:data]).to eq([])
      end
    end
  end

  describe 'GET /merchants/:id' do
    context 'merchant exists' do
      let!(:merchant) { create(:merchant) }

      before(:each) do
        get "/api/v1/merchants/#{merchant.id}"
      end

      let!(:json) { JSON.parse(response.body, symbolize_names: true) }

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end

      it "returns the data of the chosen merchant " do
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

    context 'merchant does not exist' do

      before(:each) do
        get "/api/v1/merchants/10"
      end

      let!(:json) { JSON.parse(response.body, symbolize_names: true) }

      it "returns status code 404" do
        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Merchant with 'id'=10/)
      end
    end
  end

  describe 'GET /merchants/:merchant_id/items' do
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

      it "returns a status code of 200" do
        expect(response).to have_http_status(200)
      end

      it "returns the expected data Array with 3 objects" do
        expect(json).to be_a(Hash)
        expect(json).to have_key(:data)

        expect(json[:data]).to eq([])
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
end
