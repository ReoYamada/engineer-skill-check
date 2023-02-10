class EmployeeArticle < ApplicationRecord
  belongs_to :employee
  belongs_to :article
end
