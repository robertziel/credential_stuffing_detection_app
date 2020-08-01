class Input < ApplicationRecord
  validates :email, :event_name, :ip, presence: true

  def self.detected_attack?(params)
    where(params).where('detected_at > ?', 5.seconds.ago).count > 5
  end
end
