FactoryBot.define do
  factory :address do
    ip { Faker::Internet.ip_v4_address }
  end
end
