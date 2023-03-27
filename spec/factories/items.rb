require 'faker'

FactoryBot.define do
  factory :item do
    name { Faker::Name.name }
    description { Faker::ChuckNorris.fact }
    unit_price { Faker::Number.decimal(l_digits: 2) }
  end
end