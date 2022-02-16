require 'rails_helper'

RSpec.describe 'json with Most Revenue' do
  context 'merchants exist' do
    let!(:merchant_1) { create(:merchant_with_transactions, name: 'Apple', invoice_item_quantity: 1, invoice_item_unit_price: 10.50) }
    let!(:merchant_2) { create(:merchant_with_transactions, name: 'Target', invoice_item_quantity: 2, invoice_item_unit_price: 5.00) }
    let!(:merchant_3) { create(:merchant_with_transactions, name: 'Walmart', invoice_item_quantity: 3, invoice_item_unit_price: 15.00) }
    let!(:quantity) { 3 }

    before(:each) do
      get "/api/v1/revenue/merchants?quantity=#{quantity}"
    end

    let!(:json) { JSON.parse(response.body, symbolize_names: true) }
    let!(:merchant) { json[:data][0] }

    it "returns status code 200" do
      expect(response).to have_http_status(200)
    end

    it "has an array of merchants" do
      expect(json).to be_a(Hash)
      expect(json).to have_key(:data)
      expect(json[:data]).to be_a(Array)
      expect(json[:data].length).to eq(quantity)
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

      expect(merchant[:attributes]).to have_key(:revenue)
      expect(merchant[:attributes][:revenue]).to be_a(Float)
      expect(merchant[:attributes][:revenue]).to eq(45.0)
    end
  end
end
