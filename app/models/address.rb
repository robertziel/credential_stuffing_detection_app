class Address < ApplicationRecord
  has_many :emails, dependent: :destroy
end
