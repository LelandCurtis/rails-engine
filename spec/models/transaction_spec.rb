require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'validations' do
    it { should have_many(:invoices) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:invoice_items).through(:invoices) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
  end
end
