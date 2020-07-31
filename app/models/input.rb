class Input < ApplicationRecord
  validates :email, :event_name, :ip, presence: true
end
