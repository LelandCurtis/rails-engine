require 'rails_helper'

RSpec.describe 'api/v1/merchants/find_all' do
  context 'happy paths - merchants exist' do
    let!(:merchant_1) { create(:merchant, name: 'Baseball Bat') }
    let!(:merchant_2) { create(:merchant, name: 'Cricket Bat') }
    let!(:merchant_3) { create(:merchant, name: 'Zebra') }

    context 'search by name when merchants exist' do
      let(:query) { '?name=bat' }

      before(:each) do
        get "/api/v1/merchants/find_all#{query}"
      end

      let!(:json) { JSON.parse(response.body, symbolize_names: true) }
      let!(:merchant) { json[:data].sample(1)[0] }

      it "returns a status code of 200" do
        expect(response).to have_http_status(200)
      end

      it "returns the expected array of merchant data" do
        expect(json).to be_a(Hash)
        expect(json).to have_key(:data)

        expect(json[:data]).to be_a(Array)
      end

      it "returns the expected hash structure for the merchant" do
        expect(merchant).to be_a(Hash)

        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String)

        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to be_a(String)
        expect(merchant[:type]).to eq('merchant')

        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to be_a(Hash)
      end

      it "returns the expected merchant attributes" do
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end
  end

  context 'sad paths' do
    context 'search returns 0 merchants' do
      let!(:merchant) { create(:merchant, name: "zebra") }
      before(:each) do
        get '/api/v1/merchants/find_all?name=hello'
      end

      it "returns status code 200 and empty" do
        expect(response).to have_http_status(200)
      end

      it "returns an empty response" do
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json).to be_a(Hash)
        expect(json).to have_key(:data)
        expect(json[:data]).to eq([])

        expect(json[:error]).to match(/No merchants found/)
      end
    end

    context 'search fields are empty' do
      let!(:merchant) { create(:merchant, name: "zebra") }
      before(:each) do
        get '/api/v1/merchants/find_all?name='
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
