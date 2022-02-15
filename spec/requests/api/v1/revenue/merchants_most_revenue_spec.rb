require 'rails_helper'

RSpec.describe 'Merchants with Most Revenue' do
  context 'merchants exist' do
    let!(:merchant) { create(:merchant) }
    let!(:quantity) { 3 }

    before(:each) do
      get "/api/v1/revenue/merchants?quantity=#{quantity}"
    end

    let!(:json) { JSON.parse(response.body, symbolize_names: true) }

    it "returns status code 200" do
      expect(response).to have_http_status(200)
    end

    it "has an array of merchants" do
      expect(merchants).to be_a(Hash)
      expect(merchants).to have_key(:data)
      expect(merchants[:data]).to be_a(Array)
      expect(merchants[:data].length).to eq(quantity)
    end

    it "has id, type, and attribute hash for each item" do
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq("merchant_name_revenue")

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a(Hash)
    end

    it "has an attribute hash with all required attributes " do
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
      expect(json[:data][:attributes][:name]).to eq(merchant.name)

      expect(merchant[:attributes]).to have_key(:revenue)
      expect(merchant[:attributes][:revenue]).to be_a(Float)
    end
  end
end
