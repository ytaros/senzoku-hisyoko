# frozen_string_literal: true

# == Schema Information
#
# Table name: receipts
#
#  id          :integer          not null, primary key
#  compiled_at :date
#  drink_value :integer          not null
#  food_value  :integer          not null
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
            it { expect(receipt.errors.messages[:food_value]).to include('は1以上の値にしてください') }
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
            it { expect(receipt.errors.messages[:drink_value]).to include('は1以上の値にしてください') }
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
end
