# frozen_string_literal: true

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

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 100 }
  validates :menu_id, presence: true
  validates :receipt_id, presence: true

  # 特定の注文の合計金額を返す
  def order_price
    menu.price * quantity
  end

  # トータルの合計金額を返す
  def self.total_price(receipt_id)
    where(receipt_id: receipt_id).sum(&:order_price)
  end

  # ジャンルごとに合計金額を計算する
  def self.total_by_genre(order_details, genre)
    order_details.joins(:menu).where(menus: { genre: genre }).sum('menus.price * order_details.quantity')
  end
end
