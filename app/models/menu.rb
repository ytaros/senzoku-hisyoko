# frozen_string_literal: true

# == Schema Information
#
# Table name: menus
#
#  id         :integer          not null, primary key
#  category   :string           not null
#  genre      :integer          not null
#  price      :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tenant_id  :integer          not null
#
# Indexes
#
#  index_menus_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  tenant_id  (tenant_id => tenants.id)
#
class Menu < ApplicationRecord
  enum genre: {
    food: 0,
    drink: 1
  }

  belongs_to :tenant

  validates :category, presence: true, length: { maximum: 20 }
  validates :genre, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :tenant_id, presence: true
end
