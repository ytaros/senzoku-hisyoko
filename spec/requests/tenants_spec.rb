# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tenants', type: :request do
  let(:valid_attributes) { { name: 'サンプル', industry: 'standing_bar' } }
  let(:invalid_attributes) { { name: ' ', industry: 'standing_bar' } }

  before { login(user) }

  describe 'with admin ' do
    let(:user) { create(:admin) }

    describe 'GET /index' do
      it 'テナント一覧画面に遷移する' do
        get tenants_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include('テナント一覧')
      end
    end

    describe 'GET /show' do
      let(:tenant) { create(:tenant) }

      it 'テナント詳細画面に遷移する' do
        get tenant_path(tenant)
        expect(response).to have_http_status(:success)
        expect(response.body).to include('テナント詳細')
      end
    end

    describe 'GET /new' do
      it 'テナント新規登録画面に遷移する' do
        get new_tenant_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include('テナント新規登録')
      end
    end

    describe 'POST /create' do
      subject(:action) { post tenants_path, params: { tenant: attributes } }

      context 'with valid attribute' do
        let(:attributes) { valid_attributes }

        it 'テナントが作成される' do
          expect { action }.to change(Tenant, :count).by(1)
          expect(response).to redirect_to tenants_path
          follow_redirect!
          expect(response.body).to include('テナント一覧')
        end
      end

      context 'with invalid attribute' do
        let(:attributes) { invalid_attributes }

        it 'テナントが作成されない' do
          expect { subject }.to change(Tenant, :count).by(0)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include('テナントの登録に失敗しました')
        end
      end
    end

    describe 'GET /edit' do
      let(:tenant) { create(:tenant) }

      it 'テナント編集画面に遷移する' do
        get edit_tenant_path(tenant)
        expect(response).to have_http_status(:success)
        expect(response.body).to include('テナント編集')
      end
    end

    describe 'PATCH/update' do
      let(:tenant) { create(:tenant) }

      subject(:action) { patch tenant_path(tenant), params: { tenant: attributes } }

      context 'with valid attribute' do
        let(:attributes) { { name: 'サンプル' } }

        it 'テナントが更新される' do
          expect { action }.to change { tenant.reload.name }.from(tenant.name).to(attributes[:name])
          expect(response).to redirect_to tenants_path
          follow_redirect!
          expect(response.body).to include('テナント一覧')
        end
      end

      context 'with invalid attribute' do
        let(:attributes) { invalid_attributes }

        it 'テナントが更新されない' do
          action
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include('テナントの更新に失敗しました')
        end
      end
    end

    describe 'DELETE /destroy' do
      let!(:tenant) { create(:tenant) }
      subject(:action) { delete tenant_path(tenant) }

      it 'テナントが削除される' do
        expect { action }.to change(Tenant, :count).by(-1)
        expect(response).to redirect_to tenants_path
        follow_redirect!
        expect(response.body).to include('テナント一覧')
      end
    end
  end

  describe 'with user ' do
    let(:user) { create(:user) }

    describe 'GET /index' do
      it 'ホーム画面にリダイレクトする' do
        get tenants_path
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'GET /new' do
      it 'ホーム画面にリダイレクトする' do
        get new_tenant_path
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'GET /show' do
      let(:tenant) { create(:tenant) }

      it 'ホーム画面にリダイレクトする' do
        get tenant_path(tenant)
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'POST /create' do
      subject(:action) { post tenants_path, params: { tenant: valid_attributes } }

      it 'ホーム画面にリダイレクトする' do
        expect { action }.not_to change(Tenant, :count)
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'GET /edit' do
      let(:tenant) { create(:tenant) }

      it 'ホーム画面にリダイレクトする' do
        get edit_tenant_path(tenant)
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'PATCH /update' do
      let!(:tenant) { create(:tenant) }

      subject(:action) { patch tenant_path(tenant), params: { tenant: attributes } }

      let(:attributes) { { name: 'サンプル' } }

      it 'ホーム画面にリダイレクトする' do
        expect { action }.not_to(change { tenant.reload.name })
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'DELETE /destroy' do
      let!(:tenant) { create(:tenant) }
      subject(:action) { delete tenant_path(tenant) }

      it 'テナントが削除される' do
        expect { action }.not_to change(Tenant, :count)
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end
  end
end
