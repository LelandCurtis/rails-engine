require 'rails_helper'

RSpec.describe 'api/v1/merchants/find_all' do
  context 'happy paths - merchants exist' do
    let!(:merchant_1) { create(:merchant, name: 'Baseball Bat') }
    let!(:merchant_2) { create(:merchant, name: 'Cricket Bat') }
    let!(:merchant_3) { create(:merchant, name: 'Zebra') }

    context 'search by name when merchants exist' do
      let(:query) { '?name=bat' }

      before(:each) do
        get "/api/v1/merchants/find#{query}"
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

      it "returns the expected hash structure for the merchant" do
        expect(json[:data]).to be_a(Hash)

        expect(json[:data]).to have_key(:id)
        expect(json[:data][:id]).to be_a(String)

        expect(json[:data]).to have_key(:type)
        expect(json[:data][:type]).to be_a(String)
        expect(json[:data][:type]).to eq('merchant')

        expect(json[:data]).to have_key(:attributes)
        expect(json[:data][:attributes]).to be_a(Hash)
      end

      it "returns the expected merchant attributes" do
        expect(json[:data][:attributes]).to have_key(:name)
        expect(json[:data][:attributes][:name]).to be_a(String)
      end
    end
  end

  context 'sad paths' do
    context 'search returns 0 merchants' do
      let!(:merchant) { create(:merchant, name: "zebra") }
      before(:each) do
        get '/api/v1/merchants/find?name=hello'
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
        expect(json[:data][:type]).to eq("merchant")

        expect(json[:data]).to have_key(:attributes)
        expect(json[:data][:attributes]).to be_a(Array)
        expect(json[:data][:attributes]).to eq([])

        expect(json[:error]).to match(/No records found/)
      end
    end

    context 'search fields are empty' do
      let!(:merchant) { create(:merchant, name: "zebra") }
      before(:each) do
        get '/api/v1/merchants/find?name='
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
  end

end
