require 'rails_helper'

RSpec.describe 'DESTROY /api/v1/items/:id' do
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
