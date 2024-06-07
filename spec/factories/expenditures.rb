# frozen_string_literal: true

# == Schema Information
#
# Table name: expenditures
#
#  id            :integer          not null, primary key
#  compiled_at   :date
#  expense_value :integer          not null
#  recorded_at   :date             not null
#  status        :string           default(NULL), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer          not null
#
FactoryBot.define do
  factory :expenditure do
    expense_value { 1000 }
    recorded_at { Date.today }
    status { :unrecorded }
    user
    compiled_at { nil }
  end
end
