require 'rails_helper'

RSpec.describe 'api/v1/merchants/most_items?quantity=x' do
  context 'happy paths - merchants exist' do
    let!(:merchant_1) { create(:merchant_with_transactions, name: 'Apple', invoice_item_quantity: 50) }
    let!(:merchant_2) { create(:merchant_with_transactions, name: 'Target', invoice_item_quantity: 5) }
    let!(:merchant_3) { create(:merchant_with_transactions, name: 'Walmart', invoice_item_quantity: 500) }
    let!(:merchant_4) { create(:merchant_with_transactions, name: 'Walmart', invoice_item_quantity: 5000, transaction_result: 'failed') }

    context 'items exist' do
      let(:quantity) { '3' }

      before(:each) do
        get "/api/v1/merchants/most_items?quantity=#{quantity}"
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
        expect(merchant[:type]).to eq('items_sold')

        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to be_a(Hash)
      end

      it "returns the expected merchant attributes" do
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)

        expect(merchant[:attributes]).to have_key(:count)
        expect(merchant[:attributes][:count]).to be_a(Integer)
      end
    end
  end
end
