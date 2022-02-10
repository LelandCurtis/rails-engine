require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'associations' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items).dependent(:destroy) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price) }
  end

  describe 'class methods' do
    describe '.search' do
      context 'search by name only' do
        let!(:merchant_1) { create(:merchant) }
        let!(:item_1) { create(:item, name: 'Baseball Bat', unit_price: 7.99) }
        let!(:item_2) { create(:item, name: 'Cricket Bat', unit_price: 107.99, merchant: merchant_1) }
        let!(:item_3) { create(:item, name: 'Zebra', unit_price: 2.99, merchant: merchant_1) }

        it "performs a case-insensitive search and returns one object." do
          expect(Item.search(name: 'zebra')).to eq(item_3)
        end

        it "if multiple items are found, it returns the first object found in case-sensitive alphabetical order." do
          expect(Item.search(name: 'bat')).to eq(item_1)
        end

        it "works on a subset of items" do
          expect(merchant_1.items.search(name: 'bat')).to eq(item_2)
        end

        it "returns the first case-sensitive alphabetical item by default" do
          expect(Item.search).to eq(item_1)
        end
      end

      context 'search by min unit_price only' do
        let!(:merchant_1) { create(:merchant) }
        let!(:item_1) { create(:item, name: 'Baseball Bat', unit_price: 7.99) }
        let!(:item_2) { create(:item, name: 'Cricket Bat', unit_price: 107.99, merchant: merchant_1) }
        let!(:item_3) { create(:item, name: 'Zebra', unit_price: 2.99, merchant: merchant_1) }

        it "performs returns one object." do
          expect(Item.search(min_price: 10.0)).to eq(item_2)
        end

        it "if multiple items are found, it returns the first object found in case-sensitive alphabetical order." do
          expect(Item.search(min_price: 1.00)).to eq(item_1)
        end

        it "works on a subset of items" do
          expect(merchant_1.items.search(min_price: 4.00)).to eq(item_2)
        end
      end

      context 'search by max unit_price only' do
        let!(:merchant_1) { create(:merchant) }
        let!(:item_1) { create(:item, name: 'Baseball Bat', unit_price: 7.99) }
        let!(:item_2) { create(:item, name: 'Cricket Bat', unit_price: 107.99, merchant: merchant_1) }
        let!(:item_3) { create(:item, name: 'Zebra', unit_price: 2.99, merchant: merchant_1) }

        it "performs returns one object." do
          expect(Item.search(max_price: 5.0)).to eq(item_3)
        end

        it "if multiple items are found, it returns the first object found in case-sensitive alphabetical order." do
          expect(Item.search(max_price: 120.0)).to eq(item_1)
        end

        it "works on a subset of items" do
          expect(merchant_1.items.search(max_price: 4.00)).to eq(item_3)
        end
      end

      context 'search by name, min and max unit_price' do
        let!(:merchant_1) { create(:merchant) }
        let!(:item_1) { create(:item, name: 'Baseball Bat', unit_price: 7.99) }
        let!(:item_2) { create(:item, name: 'Cricket Bat', unit_price: 107.99, merchant: merchant_1) }
        let!(:item_3) { create(:item, name: 'Battery', unit_price: 5.99) }
        let!(:item_4) { create(:item, name: 'Zebra', unit_price: 2.99, merchant: merchant_1) }
        let!(:item_5) { create(:item, name: 'Bath Towel', unit_price: 15.99, merchant: merchant_1) }

        it "performs returns one object." do
          expect(Item.search(name: 'bat', min_price: 10.0, max_price: 16.0)).to eq(item_5)
        end

        it "if multiple items are found, it returns the first object found in case-sensitive alphabetical order." do
          expect(Item.search(name: 'bat', min_price: 2.0, max_price: 15.0)).to eq(item_1)
        end

        it "works on a subset of items" do
          expect(merchant_1.items.search(name: 'bat', min_price: 6.0, max_price: 160.0)).to eq(item_5)
        end
      end
    end
  end
end
