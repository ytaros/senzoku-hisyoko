# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Expenditures', type: :request do
  let(:valid_attributes) { { expense_value: 1000, recorded_at: Date.today, status: :unrecorded } }
  let(:invalid_attributes) { { expense_value: nil, recorded_at: Date.today, status: :unrecorded } }

  before { login(user) }

  describe 'with admin ' do
    let(:user) { create(:admin) }

    describe 'GET /index' do
      it 'ホーム画面にリダイレクトする' do
        get expenditures_path
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'GET /new' do
      it 'ホーム画面にリダイレクトする' do
        get new_expenditure_path
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'POST /create' do
      subject(:action) { post expenditures_path, params: { expenditure: valid_attributes } }

      it 'ホーム画面にリダイレクトする' do
        expect { action }.not_to change(Expenditure, :count)
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'GET /edit' do
      let(:expenditure) { create(:expenditure) }

      it 'ホーム画面にリダイレクトする' do
        get edit_expenditure_path(expenditure)
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'PATCH /update' do
      let!(:expenditure) { create(:expenditure) }

      subject(:action) { patch expenditure_path(expenditure), params: { expenditure: attributes } }

      let(:attributes) { { expense_value: nil } }

      it 'ホーム画面にリダイレクトする' do
        expect { action }.not_to(change { expenditure.reload.expense_value })
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'DELETE /destroy' do
      let!(:expenditure) { create(:expenditure) }
      subject(:action) { delete expenditure_path(expenditure) }

      it 'ホーム画面にリダイレクトする' do
        expect { action }.not_to change(Expenditure, :count)
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end
  end

  describe 'with user ' do
    let(:user) { create(:user) }

    describe 'GET /index' do
      it '経費一覧画面に遷移する' do
        get expenditures_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include('経費管理')
      end
    end

    describe 'GET /new' do
      it '経費新規登録画面に遷移する' do
        get new_expenditure_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include('経費入力')
      end
    end

    describe 'POST /create' do
      subject(:action) { post expenditures_path, params: { expenditure: attributes } }

      context 'with valid attribute' do
        let(:attributes) { valid_attributes }

        it '経費が作成される' do
          expect { action }.to change(Expenditure, :count).by(1)
          expect(response).to redirect_to expenditures_path
          follow_redirect!
          expect(response.body).to include('経費管理')
        end
      end

      context 'with invalid attribute' do
        let(:attributes) { invalid_attributes }

        it '経費が作成されない' do
          expect { action }.to change(Expenditure, :count).by(0)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include('経費の登録に失敗しました')
        end
      end
    end

    describe 'GET /edit' do
      let(:expenditure) { create(:expenditure, user:) }

      it '経費編集画面に遷移する' do
        get edit_expenditure_path(expenditure)
        expect(response).to have_http_status(:success)
        expect(response.body).to include('経費編集')
      end
    end

    describe 'PATCH/update' do
      let(:expenditure) { create(:expenditure, user:) }

      subject(:action) { patch expenditure_path(expenditure), params: { expenditure: attributes } }

      context 'with valid attribute' do
        let(:attributes) { { expense_value: 10_000, status: :unrecorded } }

        it 'テナントが更新される' do
          expect { action }.to change { expenditure.reload.expense_value }.from(expenditure.expense_value).to(attributes[:expense_value])
          expect(response).to redirect_to expenditures_path
          follow_redirect!
          expect(response.body).to include('経費管理')
        end
      end

      context 'with invalid attribute' do
        let(:attributes) { invalid_attributes }

        it '経費が更新されない' do
          action
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include('経費の更新に失敗しました')
        end
      end
    end

    describe 'DELETE /destroy' do
      let!(:expenditure) { create(:expenditure, user:) }
      subject(:action) { delete expenditure_path(expenditure) }

      it '経費が削除される' do
        expect { action }.to change(Expenditure, :count).by(-1)
        expect(response).to redirect_to expenditures_path
        follow_redirect!
        expect(response.body).to include('経費管理')
      end
    end
  end
end
