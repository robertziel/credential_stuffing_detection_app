class Address < ApplicationRecord
  has_many :events, dependent: :destroy
end
