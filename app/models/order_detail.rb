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

  scope :food_for_day, ->(date, user) { joins(:menu, :receipt).where(menus: { genre: :food }, receipts: { recorded_at: date.beginning_of_day..date.end_of_day, user_id: user.id }) }
  scope :drink_for_day, ->(date, user) { joins(:menu, :receipt).where(menus: { genre: :drink }, receipts: { recorded_at: date.beginning_of_day..date.end_of_day, user_id: user.id }) }
  scope :food_for_month, ->(month, user) { joins(:menu, :receipt).where(menus: { genre: :food }, receipts: { compiled_at: month.beginning_of_month..month.end_of_month, user_id: user.id }) }
  scope :drink_for_month, ->(month, user) { joins(:menu, :receipt).where(menus: { genre: :drink }, receipts: { compiled_at: month.beginning_of_month..month.end_of_month, user_id: user.id }) }

  # 特定の注文の合計金額を返す
  def order_price
    menu.price * quantity
  end

  # ジャンルごとに合計金額を計算する
  def self.total_by_genre(receipt)
    where(receipt_id: receipt.id).joins(:menu).group('menus.genre').sum('menus.price * order_details.quantity')
  end

  # 　 円グラフで使用
  def self.format_data_for_period(scope_name, period, user)
    order_details = send(scope_name, period, user).includes(:menu)
    # menu_idごとにorder_detailsをグループ化して各グループの数量を合計
    grouped_details = order_details.group_by(&:menu_id).transform_values { |details| details.sum(&:quantity) }
    # メニュー情報をmenu_idをキーとして事前に取得し、検索用のハッシュを作成
    menu_lookup = Menu.where(id: order_details.map(&:menu_id).uniq).index_by(&:id)
    # 各menu_idに対応するメニュー情報を用いて、キーをフォーマット化
    grouped_details.transform_keys do |menu_id|
      menu = menu_lookup[menu_id]
      "#{menu.category}: #{menu.price}#{I18n.t('yen')}"
    end
  end
end
