# frozen_string_literal: true

# == Schema Information
#
# Table name: expenditures
#
#  id            :integer          not null, primary key
#  compiled_at   :date
#  expense_value :integer          not null
#  recorded_at   :date             not null
#  status        :integer          default("unrecorded"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer          not null
#
require 'rails_helper'

RSpec.describe Expenditure, type: :model do
  let(:user) { create(:user) }
  let(:expenditure) { create(:expenditure, user: user) }

  describe 'validations' do
    describe 'expense_value' do
      context 'presence' do
        before do
          expenditure.expense_value = nil
          expenditure.valid?
        end

        it { expect(expenditure.errors.messages[:expense_value]).to include('を入力してください') }
      end

      context 'numericality' do
        context 'with expense_value is not a number' do
          before do
            expenditure.expense_value = 'a'
            expenditure.valid?
          end

          it { expect(expenditure.errors.messages[:expense_value]).to include('は数値で入力してください') }
        end

        context 'with expense_value is less than 0' do
          before do
            expenditure.expense_value = -1
            expenditure.valid?
          end

          it { expect(expenditure.errors.messages[:expense_value]).to include('は0以上の値にしてください') }
        end

        context 'with expense_value is greater than 99999' do
          before do
            expenditure.expense_value = 100_000
            expenditure.valid?
          end

          it { expect(expenditure.errors.messages[:expense_value]).to include('は99999以下の値にしてください') }
        end
      end

      context 'status' do
        context 'presence' do
          before do
            expenditure.status = nil
            expenditure.valid?
          end

          it { expect(expenditure.errors.messages[:status]).to include('を入力してください') }
        end
      end

      context 'recorded_at' do
        context 'presence' do
          before do
            expenditure.recorded_at = nil
            expenditure.valid?
          end

          it { expect(expenditure.errors.messages[:recorded_at]).to include('を入力してください') }
        end
      end
    end
  end

  describe 'Scope' do
    describe '.for_month' do
      let(:month) { Date.new(2024, 6, 1) }
      let(:expenditure_a) { create(:expenditure, recorded_at: '2024-06-01', compiled_at: '2024-06-01') }
      let(:expenditure_b) { create(:expenditure, recorded_at: '2024-06-01', compiled_at: nil) }
      let(:expenditure_c) { create(:expenditure, recorded_at: '2024-05-30', compiled_at: '2024-06-01') }

      it '2024年6月の集計済みのレコードが抽出される' do
        expect(Expenditure.for_month(month)).to include(expenditure_a)
        expect(Expenditure.for_month(month)).not_to include(expenditure_b, expenditure_c)
      end
    end
  end
end
