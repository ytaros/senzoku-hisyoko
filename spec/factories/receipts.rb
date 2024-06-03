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
#  status      :integer          default("unrecorded"), not null
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
FactoryBot.define do
  factory :receipt do
    food_value { nil }
    drink_value { nil }
    status { :unrecorded }
    recorded_at { Date.today }
    user
  end

  trait :update_to_record do
    food_value { 1000 }
    drink_value { 1000 }
  end
end
