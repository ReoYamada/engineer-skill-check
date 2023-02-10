class Employee < ApplicationRecord
  belongs_to :office
  belongs_to :department
  has_many :profiles, dependent: :destroy
  has_many :employee_articles, dependent: :destroy
  has_many :articles, through: :employee_articles

  validates :number, presence: true, uniqueness: true
  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :account, presence: true, uniqueness: true
  validates :password, presence: true
  validates :email, presence: true
  validates :date_of_joining, presence: true

  scope :active, lambda {
    where(deleted_at: nil)
  }
end
