# == Schema Information
#
# Table name: order_details
#
#  id         :integer          not null, primary key
#  quantity   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  menu_id    :integer
#  receipt_id :integer
#
# Indexes
#
#  index_order_details_on_menu_id     (menu_id)
#  index_order_details_on_receipt_id  (receipt_id)
#
# Foreign Keys
#
#  menu_id     (menu_id => menus.id)
#  receipt_id  (receipt_id => receipts.id)
#
require 'rails_helper'

RSpec.describe OrderDetail, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
