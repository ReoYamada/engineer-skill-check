class Article < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
end
