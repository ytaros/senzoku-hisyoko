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
require 'rails_helper'

RSpec.describe Receipt, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
