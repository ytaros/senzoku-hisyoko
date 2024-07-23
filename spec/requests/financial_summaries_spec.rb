# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FinancialSummaries', type: :request do
  before { login(user) }

  context 'with admin' do
    let(:user) { create(:admin) }

    describe 'GET /index' do
      it 'ホーム画面にリダイレクトする' do
        get financial_summaries_path
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'GET /show' do
      let(:date) { Date.today }

      it 'ホーム画面にリダイレクトする' do
        get date_financial_summaries_path(date)
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'POST /compile' do
      it 'ホーム画面にリダイレクトする' do
        post compile_financial_summaries_path, params: { compile: { date: Date.today } }
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end
  end

  context 'with user' do
    let(:user) { create(:user) }
    let(:month) { Date.today.beginning_of_month }

    describe 'GET /index' do
      context 'when summarized records exist' do
        before do
          create(:receipt, user:, recorded_at: month + 5.days, compiled_at: month + 5.days, food_value: 1000, drink_value: 500)
          create(:expenditure, user:, recorded_at: month + 5.days, compiled_at: month + 5.days, expense_value: 500)
        end

        it '月次集計が表示され、集計日のリンクが表示される' do
          get financial_summaries_path
          expect(response).to have_http_status(:success)
          expect(response.body).to include('収支情報')
          expect(response.body).to include('売上合計:1500円')
          expect(response.body).to include('経費合計:500円')
          expect(response.body).to include('利益合計:1000円')
          expect(response.body).to include('6</a>')
        end
      end

      context 'when summarized records do not exist' do
        it '月次集計が全て0円で表示される' do
          get financial_summaries_path
          expect(response).to have_http_status(:success)
          expect(response.body).to include('収支情報')
          expect(response.body).to include('売上合計:0円')
          expect(response.body).to include('経費合計:0円')
          expect(response.body).to include('利益合計:0円')
        end
      end
    end

    describe 'GET /show' do
      before do
        create(:receipt, user:, recorded_at: '2024-06-05', compiled_at: '2024-06-05', food_value: 1000, drink_value: 500)
        create(:expenditure, user:, recorded_at: '2024-06-05', compiled_at: '2024-06-05', expense_value: 500)
      end

      it '日次集計が表示される' do
        get date_financial_summaries_path('2024-06-05')
        expect(response).to have_http_status(:success)
        expect(response.body).to include('収支情報')
        expect(response.body).to include('売上合計:1500円')
        expect(response.body).to include('経費合計:500円')
        expect(response.body).to include('利益合計:1000円')
      end
    end

    describe 'POST /compile' do
      context 'when records exist' do
        let!(:receipt) { create(:receipt, user:, recorded_at: Date.today, compiled_at: nil) }
        let!(:expenditure) { create(:expenditure, user:, recorded_at: Date.today, compiled_at: nil) }

        it '選択した日付の収支情報が集計される' do
          post compile_financial_summaries_path, params: { compile: { date: Date.today } }
          expect(response).to redirect_to financial_summaries_path
          expect(flash[:success]).to include("#{Date.today.strftime('%Y年%m月%d日')}の収支情報を集計しました")
          expect(receipt.reload.compiled_at).to be_present
          expect(expenditure.reload.compiled_at).to be_present
        end
      end

      context 'when records do not exist' do
        let!(:receipt) { create(:receipt, user:, recorded_at: Date.today, compiled_at: nil) }

        it '選択した日付の収支情報が集計されない' do
          post compile_financial_summaries_path, params: { compile: { date: Date.today } }
          expect(response).to redirect_to financial_summaries_path
          expect(flash[:danger]).to include("#{Date.today.strftime('%Y年%m月%d日')}の収支情報の入力漏れがあります")
          expect(receipt.reload.compiled_at).to be_nil
        end
      end

      context 'when invalid date is entered' do
        it 'エラーメッセージが表示される' do
          post compile_financial_summaries_path, params: { compile: { date: '' } }
          expect(response).to redirect_to financial_summaries_path
          expect(flash[:danger]).to include('集計する日付を入力してください')
        end
      end
    end
  end
end
