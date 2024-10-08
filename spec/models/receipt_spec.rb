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
require 'rails_helper'

RSpec.describe Receipt, type: :model do
  let(:user) { create(:user) }
  let(:receipt) { build(:receipt, user:) }

  describe 'Validation' do
    describe 'food_value' do
      context 'on update' do
        before { receipt.new_record? == false }

        context 'presence' do
          before do
            receipt.food_value = nil
            receipt.valid?(:update)
          end

          context 'with food_value is nil' do
            it { expect(receipt.errors.messages[:food_value]).to include('を入力してください') }
          end
        end

        context 'numericality' do
          context 'with food_value is not a number' do
            before do
              receipt.food_value = 'a'
              receipt.valid?(:update)
            end

            it { expect(receipt.errors.messages[:food_value]).to include('は数値で入力してください') }
          end

          context 'with food_value is less than 0' do
            before do
              receipt.food_value = -1
              receipt.valid?(:update)
            end
            it { expect(receipt.errors.messages[:food_value]).to include('は0以上の値にしてください') }
          end

          context 'with food_value is greater than 99999' do
            before do
              receipt.food_value = 100_000
              receipt.valid?(:update)
            end
            it { expect(receipt.errors.messages[:food_value]).to include('は99999以下の値にしてください') }
          end
        end
      end
    end

    describe 'drink_value' do
      context 'on update' do
        before { receipt.new_record? == false }
        context 'presence' do
          before do
            receipt.drink_value = nil
            receipt.valid?(:update)
          end

          context 'with drink_value is nil' do
            it { expect(receipt.errors.messages[:drink_value]).to include('を入力してください') }
          end
        end

        context 'numericality' do
          context 'with drink_value is not a number' do
            before do
              receipt.drink_value = 'a'
              receipt.valid?(:update)
            end

            it { expect(receipt.errors.messages[:drink_value]).to include('は数値で入力してください') }
          end

          context 'with drink_value is less than 0' do
            before do
              receipt.drink_value = -1
              receipt.valid?(:update)
            end
            it { expect(receipt.errors.messages[:drink_value]).to include('は0以上の値にしてください') }
          end

          context 'with drink_value is greater than 99999' do
            before do
              receipt.drink_value = 100_000
              receipt.valid?(:update)
            end
            it { expect(receipt.errors.messages[:drink_value]).to include('は99999以下の値にしてください') }
          end
        end
      end
    end

    describe 'status' do
      context 'presence' do
        before do
          receipt.status = nil
          receipt.valid?
        end

        context 'with status is nil' do
          it { expect(receipt.errors.messages[:status]).to include('を入力してください') }
        end
      end
    end

    describe 'recorded_at' do
      context 'presence' do
        before do
          receipt.recorded_at = nil
          receipt.valid?
        end

        context 'with recorded_at is nil' do
          it { expect(receipt.errors.messages[:recorded_at]).to include('を入力してください') }
        end
      end
    end

    describe 'user_id' do
      context 'presence' do
        before do
          receipt.user_id = nil
          receipt.valid?
        end

        context 'with user_id is nil' do
          it { expect(receipt.errors.messages[:user_id]).to include('を入力してください') }
        end
      end
    end
  end

  describe 'Scope' do
    describe '.for_month' do
      let(:month) { Date.new(2024, 6, 1) }
      let(:receipt_a) { create(:receipt, recorded_at: '2024-06-01', compiled_at: '2024-06-01') }
      let(:receipt_b) { create(:receipt, recorded_at: '2024-06-01', compiled_at: nil) }
      let(:receipt_c) { create(:receipt, recorded_at: '2024-05-30', compiled_at: '2024-06-01') }

      it '2024年6月の集計済みのレコードが抽出される' do
        expect(Receipt.for_month(month)).to include(receipt_a)
        expect(Receipt.for_month(month)).not_to include(receipt_b, receipt_c)
      end
    end
  end
end
