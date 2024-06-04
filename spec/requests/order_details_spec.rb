# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OrderDetails', type: :request do
  let(:owner) { create(:user) }
  let(:admin) { create(:admin) }
  let(:receipt) { create(:receipt, user: owner) }
  let(:menu) { create(:menu) }
  let(:valid_attributes) { { receipt_id: receipt.id, menu_id: menu.id, quantity: 3 } }
  let(:invalid_attributes) { { receipt_id: receipt.id, menu_id: menu.id, quantity: nil } }

  before { login(user) }

  describe 'with admin' do
    let(:user) { admin }

    describe 'POST /create' do
      subject(:action) { post order_details_path, params: { order_detail: valid_attributes } }

      it 'ホーム画面にリダイレクトされる' do
        expect { action }.not_to change(OrderDetail, :count)
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'DELETE /destroy' do
      let!(:order_detail) { create(:order_detail, menu:, receipt:) }

      subject(:action) { delete order_detail_path(order_detail) }

      it 'ホーム画面にリダイレクトされる' do
        expect { action }.not_to change(OrderDetail, :count)
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end
  end

  describe 'with user' do
    let(:user) { owner }

    describe 'POST /create' do
      subject(:action) { post order_details_path, params: { order_detail: attributes } }

      context 'with valid attributes' do
        let(:attributes) { valid_attributes }

        it 'オブジェクトが作成される' do
          expect { action }.to change(OrderDetail, :count).by(1)
          expect(response).to redirect_to edit_receipt_path(OrderDetail.last.receipt)
          follow_redirect!
          expect(response.body).to include('オーダー入力')
        end
      end

      context 'with invalid attributes' do
        let(:attributes) { invalid_attributes }

        it 'オブジェクトの作成に失敗する' do
          expect { action }.not_to change(OrderDetail, :count)
          expect(response).to redirect_to edit_receipt_path(invalid_attributes[:receipt_id])
          follow_redirect!
          expect(response.body).to include('オーダー入力')
        end
      end
    end

    describe 'DELETE /destroy' do
      let!(:order_detail) { create(:order_detail, menu:, receipt:) }

      subject(:action) { delete order_detail_path(order_detail) }

      it 'オブジェクトが削除される' do
        expect { action }.to change(OrderDetail, :count).by(-1)
        expect(response).to redirect_to edit_receipt_path(receipt)
      end
    end
  end
end
