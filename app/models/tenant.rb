# frozen_string_literal: true

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
  has_many :users, dependent: :destroy
  has_many :menus, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :industry, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[id industry name]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[menus users]
  end
end
