FactoryBot.define do
  factory :item do
    name { Faker::Lorem.word}
    done { false }
    todo { nil }
  end
end
