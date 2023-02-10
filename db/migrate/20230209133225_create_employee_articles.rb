class CreateEmployeeArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :employee_articles do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :article, null: false, foreign_key: true

      t.timestamps
    end
  end
end
