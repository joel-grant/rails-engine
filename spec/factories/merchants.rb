FactoryBot.define do
  factory :merchant do
    name { Faker::Movies::LordOfTheRings.character }
  end
end
