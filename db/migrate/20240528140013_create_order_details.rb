# frozen_string_literal: true

class CreateOrderDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :order_details do |t|
      t.integer :quantity
      t.integer :receipt_id
      t.integer :menu_id

      t.timestamps
    end

    add_foreign_key :order_details, :receipts
    add_foreign_key :order_details, :menus
    add_index :order_details, :receipt_id
    add_index :order_details, :menu_id
  end
end
