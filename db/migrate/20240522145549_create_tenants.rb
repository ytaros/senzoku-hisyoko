class CreateTenants < ActiveRecord::Migration[7.0]
  def change
    create_table :tenants do |t|
      t.string :name, null: false
      t.integer :industry, null: false, default: 1
      t.timestamps
    end
  end
end
