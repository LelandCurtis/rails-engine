FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    unit_price { 1.5 }
    merchant
  end
end
