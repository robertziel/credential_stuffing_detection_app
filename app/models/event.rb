class Event < ApplicationRecord
  belongs_to :address
  has_many :emails, dependent: :destroy
  has_many :requests, dependent: :destroy
end
