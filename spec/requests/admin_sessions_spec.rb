# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminSessions', type: :request do
  let(:admin) { create(:admin) }
  describe 'GET /new' do
    it 'ログイン画面が表示される' do
      get admin_login_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('管理者ログイン')
    end
  end

  describe 'POST /create' do
    context 'with valid params' do
      it 'ログインに成功し、ホーム画面へリダイレクトされる' do
        post admin_login_path, params: { admin_session: { login_id: admin.login_id, password: admin.password } }
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include('ホーム画面')
      end
    end

    context 'with invalid params' do
      it 'ログインに失敗し、エラーが表示される' do
        post admin_login_path, params: { admin_session: { login_id: admin.login_id, password: 'invalid' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('ログインに失敗しました')
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'ログアウトに成功し、ログイン画面へリダイレクトされる' do
      delete admin_logout_path
      expect(response).to redirect_to(admin_login_path)
      follow_redirect!
      expect(response.body).to include('ログアウトしました')
    end
  end
end
