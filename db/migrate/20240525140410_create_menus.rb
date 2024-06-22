# frozen_string_literal: true

class CreateMenus < ActiveRecord::Migration[7.0]
  def change
    create_table :menus do |t|
      t.string :category, null: false
      t.integer :price, null: false
      t.integer :genre, null: false
      t.datetime :hidden_at
      t.references :tenant, null: false, foreign_key: true
      t.timestamps
    end
  end
end
