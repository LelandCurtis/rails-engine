require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'associations' do
    it { should have_many(:items) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'class methods' do
    describe '.find_all' do
      context 'find_all by name' do
        let!(:merchant_1) { create(:merchant, name: 'Baseball Bat') }
        let!(:merchant_2) { create(:merchant, name: 'Cricket Bat') }
        let!(:merchant_3) { create(:merchant, name: 'Zebra') }

        it "performs a case-insensitive find_all and returns one object." do
          expect(Merchant.find_all(name: 'zebra')).to eq([merchant_3])
        end

        it "if multiple merchants are found, it returns the objects in case-sensitive alphabetical order." do
          expect(Merchant.find_all(name: 'bat')).to eq([merchant_1, merchant_2])
        end

        it "returns all merchants in case-sensitive alphabetical merchant by default" do
          expect(Merchant.find_all).to eq([merchant_1, merchant_2, merchant_3])
        end
      end

      context 'sad paths' do
        context 'when no merchants exist in database' do
          it "returns an empty array if merchant model is empty" do
            expect(Merchant.find_all).to eq([])
          end
        end

        context 'when find_all returns no merchants' do
          it "returns an empty array" do
            merchant = create(:merchant, name: 'zebra')
            expect(Merchant.find_all(name: 'baloon')).to eq([])
          end
        end
      end
    end

    describe 'with_most_revenue' do
      context 'merchants exist' do
        let!(:merchant_1) { create(:merchant_with_transactions, name: 'Apple', invoice_item_quantity: 1, invoice_item_unit_price: 10.50) }
        let!(:merchant_2) { create(:merchant_with_transactions, name: 'Target', invoice_item_quantity: 2, invoice_item_unit_price: 5.00) }
        let!(:merchant_3) { create(:merchant_with_transactions, name: 'Walmart', invoice_item_quantity: 3, invoice_item_unit_price: 15.00) }

        it "returns an array of merchants by total revenue" do
          expect(Merchant.with_most_revenue(3)).to eq([merchant_3, merchant_1, merchant_2])
        end

        it "returns the correct number of merchants" do
          expect(Merchant.with_most_revenue(2)).to eq([merchant_3, merchant_1])
          expect(Merchant.with_most_revenue(1)).to eq([merchant_3])
        end

        it "returns the most available" do
          expect(Merchant.with_most_revenue(5)).to eq([merchant_3, merchant_1, merchant_2])
        end
      end

      context 'when merchants with no successful transactions exist' do
        let!(:merchant_1) { create(:merchant_with_transactions, name: 'Apple', invoice_item_quantity: 1, invoice_item_unit_price: 10.50) }
        let!(:merchant_2) { create(:merchant_with_transactions, name: 'Target', invoice_item_quantity: 2, invoice_item_unit_price: 5.00) }
        let!(:merchant_3) { create(:merchant_with_transactions, name: 'Walmart', invoice_item_quantity: 3, invoice_item_unit_price: 15.00) }
        let!(:merchant_4) { create(:merchant_with_transactions, name: 'Kroger', invoice_item_quantity: 4, invoice_item_unit_price: 15.00, transaction_result: 'failed') }

        it "returns the correct array of merchants by total revenue" do
          expect(Merchant.with_most_revenue(3)).to eq([merchant_3, merchant_1, merchant_2])
        end
      end

      context 'when merchants with invoices without status shipped exist' do
        let!(:merchant_1) { create(:merchant_with_transactions, name: 'Apple', invoice_item_quantity: 1, invoice_item_unit_price: 10.50) }
        let!(:merchant_2) { create(:merchant_with_transactions, name: 'Target', invoice_item_quantity: 2, invoice_item_unit_price: 5.00) }
        let!(:merchant_3) { create(:merchant_with_transactions, name: 'Walmart', invoice_item_quantity: 3, invoice_item_unit_price: 15.00) }
        let!(:merchant_4) { create(:merchant_with_transactions, name: 'Kroger', invoice_item_quantity: 4, invoice_item_unit_price: 15.00, invoice_status: 'pending') }

        it "returns the correct array of merchants by total revenue" do
          expect(Merchant.with_most_revenue(3)).to eq([merchant_3, merchant_1, merchant_2])
        end
      end
    end
  end
end
