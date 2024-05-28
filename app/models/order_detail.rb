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
class OrderDetail < ApplicationRecord
  belongs_to :menu
  belongs_to :receipt

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 100}
  validates :menu_id, presence: true
  validates :receipt_id, presence: true
end
