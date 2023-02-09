class AddIndexNumberToEmployees < ActiveRecord::Migration[6.1]
  def change
    add_index :employees, [:number], unique: true
  end
end
