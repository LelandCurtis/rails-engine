require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'validations' do
    it { should belong_to(:invoice) }
    it { should belong_to(:item) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:merchants).through(:items) }
  end
end
