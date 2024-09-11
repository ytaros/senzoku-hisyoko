# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET /new' do
    it 'ログイン画面が表示される' do
      get login_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('ログイン')
    end
  end

  describe 'POST /create' do
    let(:user) { create(:user) }
    it 'ログインに成功し、ホーム画面へリダイレクトされる' do
      post login_path, params: { session: { login_id: user.login_id, password: user.password } }
      expect(response).to redirect_to root_path
      follow_redirect!
      expect(response.body).to include('ホーム画面')
    end
  end

  describe 'DELETE /destroy' do
    let(:user) { create(:user) }
    it 'ログアウトに成功し、ログイン画面へリダイレクトされる' do
      login(user)
      delete logout_path
      expect(response).to redirect_to login_path
      follow_redirect!
      expect(response.body).to include('ログイン')
    end
  end

  describe 'GET /guest_login' do
    before { create(:tenant, name: 'ゲスト居酒屋') } # ゲスト用テナント作成
    it 'ゲストログインに成功し、ホーム画面へリダイレクトされる' do
      get guest_login_path
      expect(response).to redirect_to root_path
      follow_redirect!
      expect(response.body).to include('ホーム画面')
      expect(response.body).to include('ゲストユーザー')
    end
  end
end
