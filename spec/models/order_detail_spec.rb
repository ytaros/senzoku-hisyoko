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
require 'rails_helper'

RSpec.describe OrderDetail, type: :model do
  let(:menu) { create(:menu) }
  let(:receipt) { create(:receipt) }
  let(:order_detail) { build(:order_detail, menu:, receipt:) }

  describe 'Validation' do
    describe 'quantity' do
      context 'presence' do
        before do
          order_detail.quantity = nil
          order_detail.valid?
        end

        context 'with category is nil' do
          it { expect(order_detail.errors.messages[:quantity]).to include('を入力してください') }
        end
      end

      context 'numericality' do
        before do
          order_detail.quantity = 'a'
          order_detail.valid?
        end

        it { expect(order_detail.errors.messages[:quantity]).to include('は数値で入力してください') }
      end

      context 'with price is not an integer' do
        before do
          order_detail.quantity = 1.1
          order_detail.valid?
        end

        it { expect(order_detail.errors.messages[:quantity]).to include('は整数で入力してください') }
      end

      context 'with greater_than_or_equal_to' do
        before do
          order_detail.quantity = 0
          order_detail.valid?
        end

        it { expect(order_detail.errors.messages[:quantity]).to include('は1以上の値にしてください') }
      end

      context 'less_than_or_equal_to' do
        before do
          order_detail.quantity = 101
          order_detail.valid?
        end

        it { expect(order_detail.errors.messages[:quantity]).to include('は100以下の値にしてください') }
      end
    end

    describe 'menu_id' do
      context 'presence' do
        before do
          order_detail.menu_id = nil
          order_detail.valid?
        end

        it { expect(order_detail.errors.messages[:menu]).to include('を入力してください') }
      end
    end

    describe 'receipt_id' do
      context 'presence' do
        before do
          order_detail.receipt_id = nil
          order_detail.valid?
        end

        it { expect(order_detail.errors.messages[:receipt]).to include('を入力してください') }
      end
    end
  end
end
