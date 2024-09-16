# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Receipts', type: :request do
  let(:owner) { create(:user) }
  let(:admin) { create(:admin) }
  let(:receipt) { create(:receipt, user: owner) }
  let(:valid_attributes) { { recorded_at: Date.today, user: owner } }
  let(:invalid_attributes) { { recorded_at: '', user: } }

  before { login(user) }

  describe 'with admin' do
    let(:user) { admin }

    describe 'GET /index' do
      it 'ホーム画面にリダイレクトする' do
        get receipts_path
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'GET /edit' do
      it 'ホーム画面にリダイレクトする' do
        get edit_receipt_path(receipt)
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'POST /create' do
      subject(:action) { post receipts_path, params: { receipt: valid_attributes } }

      it 'ホーム画面にリダイレクトされる' do
        expect { action }.not_to change(Receipt, :count)
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'PATCH /update' do
      subject(:action) { patch receipt_path(receipt), params: { receipt: attributes } }
      let(:attributes) { { food_value: 1000, drink_value: 500 } }

      it 'ホーム画面にリダイレクトされる' do
        expect { action }.not_to(change { receipt.reload.recorded_at })
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'DELETE /destroy' do
      let!(:receipt) { create(:receipt, user: owner) }

      subject(:action) { delete receipt_path(receipt) }

      it 'ホーム画面にリダイレクトされる' do
        expect { action }.not_to change(Receipt, :count)
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'DELETE /destroy_unload' do
      let!(:receipt) { create(:receipt, user: owner) }

      subject(:action) { delete destroy_unload_receipt_path(receipt) }

      it 'ホーム画面にリダイレクトされる' do
        expect { action }.not_to change(Receipt, :count)
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end
  end

  describe 'with user' do
    let(:user) { owner }

    describe 'GET /index' do
      it '伝票管理画面が表示される' do
        get receipts_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include('伝票管理')
      end
    end

    describe 'GET /edit' do
      it '伝票登録画面が表示される' do
        get edit_receipt_path(receipt)
        expect(response).to have_http_status(:success)
        expect(response.body).to include('伝票管理')
      end
    end

    describe 'POST /create' do
      subject(:action) { post receipts_path, params: { receipt: attributes } }

      context 'with valid attributes' do
        let(:attributes) { valid_attributes }

        it 'オブジェクトが作成される' do
          expect { action }.to change(Receipt, :count).by(1)
          expect(response).to redirect_to edit_receipt_path(Receipt.last)
          follow_redirect!
          expect(response.body).to include('伝票管理')
        end
      end

      context 'with invalid attributes' do
        let(:attributes) { invalid_attributes }

        it 'オブジェクトの作成に失敗する' do
          expect { action }.not_to change(Receipt, :count)
          expect(response).to redirect_to receipts_path
          follow_redirect!
          expect(response.body).to include('伝票の登録に失敗しました')
          expect(response.body).to include('伝票管理')
        end
      end
    end

    describe 'PATCH /update' do
      subject(:action) { patch receipt_path(receipt), params: { receipt: attributes } }
      let(:menu) { create(:menu, category: '肉', genre: 'food', price: 1000) }
      let!(:order_detail) { create(:order_detail, menu:, receipt:, quantity: 1) }
      let!(:attributes) { { food_value: 1000, drink_value: 0 } }

      it 'オブジェクトが更新される' do
        expect { action }.to change { receipt.reload.food_value }.from(nil).to(1000)
        expect(response).to redirect_to receipts_path
      end
    end

    describe 'DELETE /destroy' do
      let!(:receipt) { create(:receipt, user:) }

      subject(:action) { delete receipt_path(receipt) }

      it 'オブジェクトが削除される' do
        expect { action }.to change(Receipt, :count).by(-1)
        expect(response).to redirect_to receipts_path
      end
    end

    describe 'DELETE /destroy_unload' do
      let!(:receipt) { create(:receipt, user:) }

      subject(:action) { delete destroy_unload_receipt_path(receipt) }

      it 'オブジェクトが削除される' do
        expect { action }.to change(Receipt, :count).by(-1)
      end
    end
  end
end
