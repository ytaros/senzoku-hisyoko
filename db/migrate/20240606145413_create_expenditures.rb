class CreateExpenditures < ActiveRecord::Migration[7.0]
  def change
    create_table :expenditures do |t|
      t.integer :expense_value, null: false
      t.string :status, null: false, default: '0'
      t.date :compiled_at
      t.date :recorded_at
      t.integer :user_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
