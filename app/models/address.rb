class Address < ApplicationRecord
  has_many :events, dependent: :destroy

  def ban!
    update_column(:banned_at, DateTime.now)
  end
end
