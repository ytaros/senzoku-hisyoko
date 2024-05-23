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

    describe 'GET /new' do
      it 'テナント新規登録画面に遷移する' do
        get new_tenant_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include('テナント新規作成')
      end
    end

    describe 'GET /create' do
      subject(:action) { post tenants_path, params: { tenant: attributes } }

      context 'with valid attribute' do
        let(:attributes) { valid_attributes }

        it 'テナントが作成される' do
          expect { action }.to change(Tenant, :count).by(1)
          expect(response).to redirect_to(tenants_path)
          follow_redirect!
          expect(response.body).to include('テナント一覧')
        end
      end

      context 'with invalid attribute' do
        let(:attributes) { invalid_attributes }

        it 'テナントが作成されない' do
          expect { subject }.to change(Tenant, :count).by(0)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include('テナントの新規登録に失敗しました')
        end
      end
    end

    describe 'GET /destroy' do
      let!(:tenant) { create(:tenant) }
      subject(:action) { delete tenant_path(tenant) }

      it 'テナントが削除される' do
        expect { action }.to change(Tenant, :count).by(-1)
        expect(response).to redirect_to(tenants_path)
        follow_redirect!
        expect(response.body).to include('テナント一覧')
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

    describe 'GET /update' do
      let(:tenant) { create(:tenant) }
      subject(:action) { patch tenant_path(tenant), params: { tenant: attributes } }

      context 'with valid attribute' do
        let(:attributes) { { name: 'サンプル' } }

        it 'テナントが更新される' do
          expect { action }.to change { tenant.reload.name }.from(tenant.name).to(attributes[:name])
          expect(response).to redirect_to(tenants_path)
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
  end
end
