# == Schema Information
#
# Table name: tenants
#
#  id         :integer          not null, primary key
#  industry   :integer          default("standing_bar"), not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tenant < ApplicationRecord
  enum industry: {
  standing_bar: 1
  }

  validates :name, presence: true, uniqueness: true
  validates :industry, presence: true
end
