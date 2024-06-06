# == Schema Information
#
# Table name: expenditures
#
#  id            :integer          not null, primary key
#  compiled_at   :date
#  expense_value :integer          not null
#  recorded_at   :date
#  status        :string           default("0"), not null
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
end
