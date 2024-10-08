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
FactoryBot.define do
  factory :tenant do
    name { |n| "sample#{n}" }
    industry { 'standing_bar' }
  end
end
