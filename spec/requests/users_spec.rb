# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:tenant) { create(:tenant) }
  let(:valid_attributes) { { name: 'サンプル', login_id: 'abcd1234', password: 'pass1234', password_confirmation: 'pass1234', tenant_id: tenant.id } }
  let(:invalid_attributes) { { name: ' ', industry: 'standing_bar' } }

  describe 'with admin ' do
    let(:user) { create(:admin) }

    before { login(user) }

    # 　ユーザ
    # describe 'GET /index' do
    #   it 'ユーザ一覧画面に遷移する' do
    #     get users_path
    #     expect(response).to have_http_status(:success)
    #     expect(response.body).to include 'ユーザ一覧'
    #   end
    # end

    describe 'GET /new' do
      it 'ユーザ作成画面へ遷移する' do
        get new_user_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include('ユーザ登録')
      end
    end

    describe 'POST /create' do
      subject(:action) { post users_path, params: { user: attributes } }

      context 'with valid attribute' do
        let(:attributes) { valid_attributes }

        it 'ユーザ新規登録に成功する' do
          expect { action }.to change(User, :count).by(1)
          user = User.find_by(login_id: valid_attributes[:login_id])
          expect(user).not_to be_nil
          expect(session[:user_id]).to eq(user.id)
          expect(response).to redirect_to tenants_path
          follow_redirect!
          expect(response.body).to include 'テナント一覧'
        end
      end

      context 'with invalid attribute' do
        let(:attributes) { invalid_attributes }

        it 'ユーザ新規登録に失敗する' do
          expect { subject }.to change(User, :count).by(0)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include('ユーザの登録に失敗しました')
        end
      end
    end

    describe 'GET /show' do
      let(:user_a) { create(:user) }
      it 'ユーザ情報画面へ遷移する' do
        get user_path(user_a)
        expect(response).to have_http_status(:success)
        expect(response.body).to include('ユーザ情報')
      end
    end

    describe 'GET /edit' do
      let(:user_a) { create(:user) }
      it 'ユーザ編集画面へ遷移する' do
        get edit_user_path(user_a)
        expect(response).to have_http_status(:success)
        expect(response.body).to include('ユーザ編集')
      end
    end

    describe 'PARCH /update' do
      let!(:user_a) { create(:user, name: 'サンプル') }

      subject(:action) { patch user_path(user_a), params: { user: attributes } }

      context 'with valid attribute' do
        let(:attributes) { { name: 'テスト', password: 'pass1234', password_confirmation: 'pass1234' } }

        it 'ユーザ情報の更新に成功する' do
          expect { action }.to change { user_a.reload.name }.from(user_a.name).to('テスト')
          expect(response).to redirect_to tenants_path
          follow_redirect!
          expect(response.body).to include('テナント一覧')
        end
      end

      context 'with invalid attribute' do
        let(:attributes) { { name: '' } }

        it 'ユーザ情報の更新に失敗する' do
          expect { action }.not_to(change { user_a.reload.name })
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include('ユーザの更新に失敗しました')
        end
      end
    end

    describe 'DELETE /destroy' do
      let!(:user_a) { create(:user) }

      subject(:action) { delete user_path(user_a) }
      it 'ユーザが削除され、一覧に戻る' do
        expect { action }.to change(User, :count).by(-1)
        expect(response).to redirect_to tenants_path
        follow_redirect!
        expect(response.body).to include('テナント一覧')
      end
    end
  end

  context 'when the user is logged in' do
    let(:user) { create(:user) }

    before { login(user) }

    describe 'GET /index' do
      it 'ホーム画面にリダイレクトする' do
        get users_path
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'GET /new' do
      it 'ユーザ新規作成画面へ遷移する' do
        get new_user_path
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'POST /create' do
      subject(:action) { post users_path, params: { user: attributes } }

      let(:attributes) { valid_attributes }

      it 'ホーム画面にリダイレクトする' do
        action
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end

    describe 'GET /show' do
      let(:user) { create(:user) }
      it 'ユーザ情報画面へ遷移する' do
        get user_path(user)
        expect(response).to have_http_status(:success)
        expect(response.body).to include('ユーザ情報')
      end
    end

    describe 'GET /edit' do
      let(:user) { create(:user) }
      it 'ユーザ編集画面へ遷移する' do
        get edit_user_path(user)
        expect(response).to have_http_status(:success)
        expect(response.body).to include('ユーザ編集')
      end
    end

    describe 'PATCH /update' do
      subject(:action) { patch user_path(user), params: { user: attributes } }

      context 'with valid attribute' do
        let(:attributes) { { name: 'テスト', password: 'pass1234', password_confirmation: 'pass1234' } }

        it 'ユーザ情報の更新に成功する' do
          expect { action }.to change { user.reload.name }.from(user.name).to('テスト')
          expect(response).to redirect_to root_path
          follow_redirect!
          expect(response.body).to include '<title>ホーム画面 | 専属ひしょ子ちゃん</title>'
        end
      end

      context 'with invalid attribute' do
        let(:attributes) { { name: '' } }

        it 'ユーザ情報の更新に失敗する' do
          expect { action }.not_to(change { user.reload.name })
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include('ユーザの更新に失敗しました')
        end
      end
    end

    describe 'GET /destroy' do
      subject(:action) { delete user_path(user) }

      it 'ホーム画面へリダイレクト' do
        expect { action }.not_to change(User, :count)
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to include '操作権限がありません'
      end
    end
  end
end
