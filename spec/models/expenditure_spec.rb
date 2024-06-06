# == Schema Information
#
# Table name: expenditures
#
#  id            :integer          not null, primary key
#  compiled_at   :date
#  expense_value :integer          not null
#  recorded_at   :date             not null
#  status        :string           default(NULL), not null
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
end
