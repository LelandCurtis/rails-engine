FactoryBot.define do
  factory :invoice_item do
    item
    invoice
    quantity { Faker::Number.between(from: 1, to: 10) }
    unit_price { Faker::Number.between(from: 1.00, to: 10.00) }
  end
end
