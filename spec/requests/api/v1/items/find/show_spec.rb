require 'rails_helper'

RSpec.describe 'api/v1/items/find' do
  context 'happy paths - items exist' do
    let!(:item_1) { create(:item, name: 'Baseball Bat', unit_price: 7.99) }
    let!(:item_2) { create(:item, name: 'Cricket Bat', unit_price: 107.99) }
    let!(:item_3) { create(:item, name: 'Zebra', unit_price: 2.99) }

    context 'search by name when items exist' do
      let(:query) { '?name=bat' }

      before(:each) do
        get "/api/v1/items/find#{query}"
      end

      let!(:json) { JSON.parse(response.body, symbolize_names: true) }

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

    context 'search by min_price when items exist' do
      let(:query) { '?min_price=5.00' }

      before(:each) do
        get "/api/v1/items/find#{query}"
      end

      let!(:json) { JSON.parse(response.body, symbolize_names: true) }

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
  end

  context 'sad paths' do
    context 'search returns 0 items' do
      let!(:item) { create(:item, name: "zebra") }
      before(:each) do
        get '/api/v1/items/find?name=hello'
      end

      it "returns status code 200 and empty" do
        expect(response).to have_http_status(200)
      end

      it "returns an empty response" do
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json).to be_a(Hash)
        expect(json).to have_key(:data)
        expect(json[:data]).to be_a(Hash)

        expect(json[:data]).to have_key(:id)
        expect(json[:data][:id]).to eq(nil)

        expect(json[:data]).to have_key(:type)
        expect(json[:data][:type]).to be_a(String)
        expect(json[:data][:type]).to eq("item")

        expect(json[:data]).to have_key(:attributes)
        expect(json[:data][:attributes]).to be_a(Array)
        expect(json[:data][:attributes]).to eq([])

        expect(json[:error]).to match(/No records found/)
      end
    end

    context 'search fields are empty' do
      let!(:item) { create(:item, name: "zebra") }
      before(:each) do
        get '/api/v1/items/find?name='
      end

      it "returns status code 400 and empty" do
        expect(response).to have_http_status(400)
      end

      it "returns an error response" do
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json).to be_a(Hash)
        expect(json).to have_key(:data)
        expect(json[:data]).to eq([])

        expect(json).to have_key(:error)
        expect(json[:error]).to match(/Bad request/)
      end
    end

    context 'search fields include both name and min_price' do
      let!(:item) { create(:item, name: "zebra") }
      before(:each) do
        get "/api/v1/items/find?name=zebra&min_price=50"
      end

      it "returns status code 400 and empty" do
        expect(response).to have_http_status(400)
      end

      it "returns an error response" do
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json).to be_a(Hash)
        expect(json).to have_key(:data)
        expect(json[:data]).to eq([])

        expect(json).to have_key(:error)
        expect(json[:error]).to match(/Bad request/)
      end
    end

    context 'search fields include both name and max_price' do
      let!(:item) { create(:item, name: "zebra") }
      before(:each) do
        get "/api/v1/items/find?name=zebra&max_price=50"
      end

      it "returns status code 400 and empty" do
        expect(response).to have_http_status(400)
      end

      it "returns an error response" do
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json).to be_a(Hash)
        expect(json).to have_key(:data)
        expect(json[:data]).to eq([])

        expect(json).to have_key(:error)
        expect(json[:error]).to match(/Bad request/)
      end
    end

    context 'search fields include name, min_price and max_price' do
      let!(:item) { create(:item, name: "zebra") }
      before(:each) do
        get "/api/v1/items/find?name=zebra&max_price=50&max_price=500"
      end

      it "returns status code 400" do
        expect(response).to have_http_status(400)
      end

      it "returns an error response" do
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json).to be_a(Hash)
        expect(json).to have_key(:data)
        expect(json[:data]).to eq([])

        expect(json).to have_key(:error)
        expect(json[:error]).to match(/Bad request/)
      end
    end

  end

end
