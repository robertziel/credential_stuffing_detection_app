class Input < ApplicationRecord
  validates :email, :event_name, :ip, presence: true

  def self.detected_attack?(_params)
    false
  end
end
