class Email < ApplicationRecord
  belongs_to :address
  has_many :events, dependent: :destroy
end
