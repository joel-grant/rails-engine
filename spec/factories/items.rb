FactoryBot.define do
  factory :item do
    name { Faker::Movies::StarWars.vehicle }
    description { Faker::Movies::PrincessBride.quote }
    unit_price { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
  end
end
