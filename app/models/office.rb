class Office < ApplicationRecord
  has_many :employees, dependent: :destroy
end
