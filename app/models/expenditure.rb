# frozen_string_literal: true

# == Schema Information
#
# Table name: expenditures
#
#  id            :integer          not null, primary key
#  compiled_at   :date
#  expense_value :integer          not null
#  recorded_at   :date             not null
#  status        :integer          default("unrecorded"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer          not null
#
class Expenditure < ApplicationRecord
  enum status: {
    unrecorded: 0, # 未計上
    recorded: 1 # 計上済
  }

  belongs_to :user

  validates :expense_value, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 99_999 }
  validates :status, presence: true
  validates :recorded_at, presence: true

  scope :for_month, ->(month) { where(recorded_at: month.beginning_of_month..month.end_of_month).where.not(compiled_at: nil) }
end
