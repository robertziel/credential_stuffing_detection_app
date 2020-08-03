class Request < ApplicationRecord
  belongs_to :event

  scope :recently_detected, -> {
    where('detected_at > ?', CSDApp.sample_period.seconds.ago)
  }
end
