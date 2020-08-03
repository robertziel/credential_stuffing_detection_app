class Email < ApplicationRecord
  belongs_to :event

  scope :recently_detected, -> {
    where('last_detected_at > ?', CSDApp.sample_period.seconds.ago)
  }
end
