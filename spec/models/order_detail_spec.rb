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
  let(:receipt) { create(:receipt, :update_to_record) }
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

  describe 'Instance method' do
    describe '#order_price' do
      let(:menu) { create(:menu, price: 100) }
      let(:order_detail) { build(:order_detail, menu: menu, quantity: 2) }

      it 'オーダーの値段が返ってくる' do
        expect(order_detail.order_price).to eq 200
      end
    end
  end

  describe 'Class method' do
    let(:user) { create(:user) }

    describe '.total_by_genre' do
      let!(:food) { create(:menu, genre: 'food', price: 100) }
      let!(:drink) { create(:menu, genre: 'drink', price: 200) }
      let!(:receipt) { create(:receipt) }

      before do
        create(:order_detail, menu: food, receipt:, quantity: 2)
        create(:order_detail, menu: drink, receipt:, quantity: 3)
      end

      it 'ジャンルごとの合計金額が返ってくる' do
        expect(OrderDetail.total_by_genre(receipt)).to eq({ 'food' => 200, 'drink' => 600 })
      end
    end

    describe '.format_data_for_period' do
      context 'with month' do
        let(:food) { create(:menu, id: 1, genre: :food, category: 'food', price: 100) }
        let(:drink) { create(:menu, id: 2, genre: :drink, category: 'drink', price: 200) }
        let(:receipt_a) { create(:receipt, compiled_at: Date.new(2024, 6, 3), user:) }
        let(:receipt_b) { create(:receipt, compiled_at: Date.new(2024, 6, 2), user:) }
        let(:month) { Date.new(2024, 6, 1) }

        before do
          create(:order_detail, menu: food, receipt: receipt_a, quantity: 5)
          create(:order_detail, menu: drink, receipt: receipt_a, quantity: 3)
          create(:order_detail, menu: food, receipt: receipt_b, quantity: 3)
          create(:order_detail, menu: drink, receipt: receipt_b, quantity: 2)
        end

        it 'キーがフォーマット化され、値が合計されたハッシュで返ってくる' do
          expect(OrderDetail.format_data_for_period(:food_for_month, month, user)).to eq({ 'food: 100円' => 8 })
          expect(OrderDetail.format_data_for_period(:drink_for_month, month, user)).to eq({ 'drink: 200円' => 5 })
        end
      end

      context 'with day' do
        let!(:food) { create(:menu, genre: :food, category: 'food', price: 100) }
        let!(:drink) { create(:menu, genre: :drink, category: 'drink', price: 200) }
        let!(:receipt) { create(:receipt, recorded_at: 1.days.ago, compiled_at: 1.days.ago, user:) }

        before do
          create(:order_detail, menu: food, receipt:, quantity: 2)
          create(:order_detail, menu: drink, receipt:, quantity: 3)
        end

        it 'キーがフォーマット化され、値が合計されたハッシュで返ってくる' do
          expect(OrderDetail.format_data_for_period(:food_for_day, receipt.recorded_at, user)).to eq({ 'food: 100円' => 2 })
          expect(OrderDetail.format_data_for_period(:drink_for_day, receipt.recorded_at, user)).to eq({ 'drink: 200円' => 3 })
        end
      end
    end
  end
end
