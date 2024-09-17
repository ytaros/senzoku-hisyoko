# frozen_string_literal: true

# == Schema Information
#
# Table name: receipts
#
#  id          :integer          not null, primary key
#  compiled_at :date
#  drink_value :integer
#  food_value  :integer
#  recorded_at :date             not null
#  status      :integer          default("in_progress"), not null
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
  has_many :order_details, dependent: :destroy

  enum status: {
    in_progress: 0, # 処理中
    unrecorded: 1, # 未計上
    recorded: 2 # 計上済
  }

  validates :food_value, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 99_999 }, on: :update
  validates :drink_value, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 99_999 }, on: :update
  validates :status, presence: true
  validates :recorded_at, presence: true, on: :create
  validates :user_id, presence: true, on: :create

  scope :for_month, ->(month) { where(recorded_at: month.beginning_of_month..month.end_of_month).where.not(compiled_at: nil) }
  scope :for_user, ->(user) { where(user: user) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[recorded_at status]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user order_details]
  end
end
