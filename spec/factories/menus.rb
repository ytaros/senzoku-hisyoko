# frozen_string_literal: true

# == Schema Information
#
# Table name: menus
#
#  id         :integer          not null, primary key
#  category   :string           not null
#  genre      :integer          not null
#  hidden_at  :datetime
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
FactoryBot.define do
  factory :menu do
    category { '肉料理' }
    price { 1000 }
    genre { 0 }
    tenant
  end

  trait :drink do
    category { 'ビール' }
    price { 500 }
    genre { 1 }
  end
end
