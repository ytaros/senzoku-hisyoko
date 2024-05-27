# == Schema Information
#
# Table name: receipts
#
#  id          :integer          not null, primary key
#  compiled_at :date
#  drink_value :integer          not null
#  food_value  :integer          not null
#  recorded_at :date             not null
#  status      :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_receipts_on_recorded_at  (recorded_at)
#  index_receipts_on_status       (status)
#  index_receipts_on_user_id      (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Receipt < ApplicationRecord
  belongs_to :user
  has_many :receipt_items, dependent: :destroy
  has_many :items, through: :receipt_items

  enum status: {
    unrecorded: 0, #未計上
    recorded: 1 #計上済
  }

  validates :food_value, presence: true,  numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9_999_999 }
  validates :drink_value, presence: true,  numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9_999_999 }
  validates :status, presence: true
  validates :recorded_at, presence: true
  validates :user_id, presence: true
end
