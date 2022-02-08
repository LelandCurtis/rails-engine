FactoryBot.define do
  factory :transaction do
    invoice
    credit_card_number { Faker::Number.leading_zero_number(digits: 16).to_s }
    credit_card_expiration_date { "04/23" }
    result { "success" }
  end
end
