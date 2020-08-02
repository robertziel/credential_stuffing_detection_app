FactoryBot.define do
  factory :email do
    last_detected_at { DateTime.now }
  end
end
