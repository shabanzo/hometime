# frozen_string_literal: true

FactoryBot.define do
  factory :reservation do
    association :guest
    code { Faker::Alphanumeric.unique.alphanumeric(number: 12) }
    start_date { Faker::Date.forward(days: 10) }
    end_date { start_date + Faker::Number.between(from: 1, to: 7).days }
    nights { (end_date - start_date).to_i }
    adults { Faker::Number.between(from: 1, to: 4) }
    children { Faker::Number.between(from: 0, to: 2) }
    infants { Faker::Number.between(from: 0, to: 1) }
    guests { adults + children + infants }
    payout_price { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    security_price { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    total_price { payout_price.to_f + security_price.to_f }
    currency { Faker::Currency.code }
    status { Reservation.statuses.keys.sample }
  end
end
