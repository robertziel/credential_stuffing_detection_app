class Address < ApplicationRecord
  has_many :emails, dependent: :destroy
  has_many :events, through: :emails
end
