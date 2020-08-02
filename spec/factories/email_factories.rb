FactoryBot.define do
  factory :email do
    value { Faker::Internet.email }
    last_detected_at { DateTime.now }
  end
end
