# frozen_string_literal: true

class CreateReceipts < ActiveRecord::Migration[7.0]
  def change
    create_table :receipts do |t|
      t.integer :food_value
      t.integer :drink_value
      t.integer :status, null: false, default: 0
      t.date :compiled_at
      t.date :recorded_at, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end

    add_index :receipts, :status
    add_index :receipts, :recorded_at
  end
end
