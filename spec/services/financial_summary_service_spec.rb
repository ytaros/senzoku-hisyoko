# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FinancialSummaryService', type: :service do
  let(:date) { Date.new(2024, 6, 5) }

  describe '.summarize' do
    context 'when compiled records exist' do
      let(:month) { Date.new(2024, 6, 1) }
      before do
        create(:receipt, recorded_at: date, compiled_at: date)
        create(:receipt, recorded_at: Date.new(2024, 6, 6), compiled_at: nil)
        create(:expenditure, recorded_at: date, compiled_at: date)
      end

      it '集計済みレコードの日付が配列で返る' do
        result = FinancialSummaryService.summarize(month)
        expect(result.size).to eq 1
        expect(result.map(&:date).first).to eq date
      end
    end

    context 'when compiled records do not exist' do
      let(:month) { Date.new(2024, 6, 1) }
      before do
        create(:receipt, recorded_at: Date.new(2024, 6, 6), compiled_at: nil)
      end

      it '空の配列が返る' do
        result = FinancialSummaryService.summarize(month)
        expect(result).to be_empty
      end
    end
  end

  describe '.daily_summary' do
    before do
      create(:receipt, recorded_at: date, food_value: 1000, drink_value: 500, compiled_at: date)
      create(:expenditure, recorded_at: date, expense_value: 500, compiled_at: date)
    end

    it 'returns daily summarized records' do
      result = FinancialSummaryService.daily_summary(date)

      expect(result[:date]).to eq date
      expect(result[:total_revenue]).to eq 1500
      expect(result[:total_expense]).to eq 500
      expect(result[:profit]).to eq 1000
    end
  end

  describe '.monthly_summary' do
    before do
      create(:receipt, recorded_at: date, food_value: 1000, drink_value: 500, compiled_at: date)
      create(:receipt, recorded_at: Date.new(2024, 6, 6), food_value: 2000, drink_value: 500, compiled_at: Date.new(2024, 6, 6))
      create(:expenditure, recorded_at: date, expense_value: 500, compiled_at: date)
    end

    context 'when compiled records exist' do
      let(:month) { Date.new(2024, 6, 1) }

      it 'returns monthly summarized records' do
        result = FinancialSummaryService.monthly_summary(month)

        expect(result[:total_revenue]).to eq 4000
        expect(result[:total_expense]).to eq 500
        expect(result[:profit]).to eq 3500
      end
    end

    context 'when compiled records do not exist' do
      let(:month) { Date.new(2024, 7, 1) }

      it 'returns monthly summarized records' do
        result = FinancialSummaryService.monthly_summary(month)

        expect(result[:total_revenue]).to eq 0
        expect(result[:total_expense]).to eq 0
        expect(result[:profit]).to eq 0
      end
    end
  end

  describe '.compile_for_date' do
    context 'when unrecorded receipt and expenditure exist' do
      let!(:receipt) { create(:receipt, recorded_at: date, compiled_at:nil, status: 'unrecorded') }
      let!(:expenditure) { create(:expenditure, recorded_at: date, compiled_at:nil, status: 'unrecorded') }

      it 'レコードが集計される' do
        FinancialSummaryService.compile_for_date(date)
        expect(receipt.reload.compiled_at).to eq Date.current
        expect(expenditure.reload.compiled_at).to eq Date.current
        expect(receipt.reload.status).to eq 'recorded'
        expect(expenditure.reload.status).to eq 'recorded'
      end
    end

    context 'when unrecorded receipt and expenditure do not exist' do
      let!(:receipt) { create(:receipt, recorded_at: date, compiled_at: date, status: 'recorded') }
      let!(:expenditure) { create(:expenditure, recorded_at: date, compiled_at: date, status: 'recorded') }

      it 'returns false' do
        result = FinancialSummaryService.compile_for_date(date)
        expect(result).to be_falsey
      end
    end
  end
end
