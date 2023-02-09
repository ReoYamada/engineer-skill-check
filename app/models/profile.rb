class Profile < ApplicationRecord
  belongs_to :employee

  validates :profile, length: { minimum: 1, maximum: 300 }

  scope :active, lambda {
    where(deleted_at: nil)
  }
end
