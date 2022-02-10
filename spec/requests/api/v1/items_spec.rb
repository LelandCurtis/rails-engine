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

  describe 'PATCH /api/v1/items/:id' do
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

  describe 'DESTROY /api/v1/items/:id' do
    context 'item exists' do
      let!(:item) { create(:item) }
      let!(:item_id) { item.id }

      before(:each) do
        delete "/api/v1/items/#{item.id}"
      end

      it "has correct 204 response" do
        expect(response).to have_http_status(204)
      end

      it "returns no body" do
        expect(response.body).to be_empty
      end

      it "deletes the item" do
        expect(Item.exists?(item_id)).to eq(false)
      end
    end

    context 'item does not exist'do

      before(:each) do
        delete "/api/v1/items/22"
      end

      it "has correct 404 response and error message" do
        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Item with 'id'=22/)
      end
    end

    context 'item is the only item on an invoice' do
      let!(:item) { create(:item) }
      let!(:invoice) { create(:invoice) }
      let!(:invoice_item) { create(:invoice_item, item: item, invoice: invoice) }
      let(:item_id) { item.id }
      let!(:invoice_id) { invoice.id }
      let!(:invoice_item_id) { invoice_item.id }

      before(:each) do
        delete "/api/v1/items/#{item.id}"
      end

      it "has correct 204 response" do
        expect(response).to have_http_status(204)
      end

      it "returns no body" do
        expect(response.body).to be_empty
      end

      it "deletes the item" do
        expect(Item.exists?(item_id)).to eq(false)
      end

      xit "deletes the invoice" do
        expect(Invoice.exists?(invoice_id)).to eq(false)
      end

      it "deletes the invoice_item" do
        expect(InvoiceItem.exists?(invoice_item_id)).to eq(false)
      end
    end
  end

  describe 'GET api.v1/items/:id/merchant' do
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
end
