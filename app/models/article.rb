class Article < ApplicationRecord
  has_many :employee_articles, dependent: :destroy
  has_many :employees, through: :employee_articles
  validates :title, presence: true, length: { maximum: 50 }
end
