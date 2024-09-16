# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Menus', type: :request do
  let(:tenant) { create(:tenant) }
  let(:valid_attributes) { { category: 'サンプル', genre: 'food', price: 1000, tenant_id: tenant.id } }
  let(:invalid_attributes) { { category: ' ', genre: 'food', price: 1000, tenant_id: tenant.id } }

  before { login(user) }

  describe 'with admin' do
    let(:user) { create(:admin) }

    describe 'GET /index' do
      it 'メニュー一覧画面に遷移する' do
        get menus_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include('メニュー一覧')
      end
    end

    describe 'GET /new' do
      it 'ホーム画面にリダイレクトする' do
        get new_menu_path
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'GET /show' do
      let!(:menu) { create(:menu) }
      it 'ホーム画面にリダイレクトする' do
        get menu_path(menu)
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'POST /create' do
      subject(:action) { post menus_path, params: { menu: attributes } }
      let(:attributes) { valid_attributes }

      it 'ホーム画面にリダイレクトする' do
        expect { action }.not_to change(Menu, :count)
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'GET /edit' do
      let(:menu) { create(:menu) }

      it 'ホーム画面にリダイレクトする' do
        get edit_menu_path(menu)
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'PATCH /update' do
      let(:menu) { create(:menu) }
      let(:attributes) { { category: 'テスト' } }

      subject(:action) { patch menu_path(menu), params: { menu: attributes } }

      it 'ホーム画面にリダイレクトする' do
        expect { action }.not_to(change { tenant.reload.name })
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'DELETE /hide' do
      let!(:menu) { create(:menu) }
      subject(:action) { patch hide_menu_path(menu) }

      it 'ホーム画面にリダイレクトする' do
        expect { action }.not_to(change { menu.reload.hidden_at })
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end
  end

  describe 'with user' do
    let(:user) { create(:user, tenant: tenant) }

    describe 'GET /index' do
      it 'メニュー管理画面に遷移する' do
        get menus_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include('メニュー管理')
      end
    end

    describe 'GET /new' do
      it 'メニュー登録画面に遷移する' do
        get new_menu_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include('メニュー登録')
      end
    end

    describe 'GET /show' do
      let(:menu) { create(:menu, tenant:) }

      it 'メニュー詳細画面に遷移する' do
        get menu_path(menu)
        expect(response).to have_http_status(:success)
        expect(response.body).to include('メニュー詳細')
      end
    end

    describe 'POST /create' do
      subject(:action) { post menus_path, params: { menu: attributes } }

      context 'with valid attribute' do
        let(:attributes) { valid_attributes }

        it 'メニューが登録される' do
          expect { action }.to change(Menu, :count).by(1)
          expect(response).to redirect_to menus_path
          follow_redirect!
          expect(response.body).to include('メニュー管理')
        end
      end

      context 'with invalid attribute' do
        let(:attributes) { invalid_attributes }

        it 'メニューが登録されない' do
          expect { action }.not_to change(Menu, :count)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include('メニューの登録に失敗しました')
        end
      end
    end

    describe 'GET /edit' do
      let(:menu) { create(:menu, tenant: tenant) }

      it 'メニュー編集画面に遷移する' do
        get edit_menu_path(menu)
        expect(response).to have_http_status(:success)
        expect(response.body).to include('メニュー編集')
      end
    end

    describe 'PATCH /update' do
      let(:menu) { create(:menu, tenant: tenant) }
      let(:attributes) { { category: 'テスト' } }

      subject(:action) { patch menu_path(menu), params: { menu: attributes } }

      context 'with valid attribute' do
        it 'メニュー情報の更新に成功する' do
          expect { action }.to change { menu.reload.category }.from(menu.category).to('テスト')
          expect(response).to redirect_to menu_path(menu)
        end
      end

      context 'with invalid attribute' do
        let(:attributes) { { category: ' ' } }

        it 'メニュー情報の更新に失敗する' do
          expect { action }.not_to(change { menu.reload.category })
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'DELETE /hide' do
      let!(:menu) { create(:menu, tenant: tenant, hidden_at: nil) }

      subject(:action) { patch hide_menu_path(menu) }

      it 'メニューが無効化され、管理画面に戻る' do
        expect { action }.to change { menu.reload.hidden_at }.from(nil).to(be_present)
        expect(response).to redirect_to menus_path
        follow_redirect!
        expect(response.body).to include('メニュー管理')
      end
    end
  end
end
