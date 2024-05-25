# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:tenant) { create(:tenant) }
  let(:valid_attributes) { { name: 'サンプル', login_id: '12345678', password: 'password', password_confirmation: 'password', tenant_id: tenant.id } }
  let(:invalid_attributes) { { name: ' ', industry: 'standing_bar' } }

  describe 'with admin ' do
    let(:user) { create(:admin) }

    before { login(user) }

    describe 'GET /index' do
      it 'ユーザー一覧画面に遷移する' do
        get users_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include('ユーザー一覧')
      end
    end

    describe 'GET /new' do
      it 'ユーザー新規作成画面へ遷移する' do
        get new_user_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include('ユーザー新規作成')
      end
    end

    describe 'GET /show' do
      let(:user_a) { create(:user) }
      it 'ユーザー詳細画面へ遷移する' do
        get user_path(user_a)
        expect(response).to have_http_status(:success)
        expect(response.body).to include('ユーザー詳細')
      end
    end

    describe 'GET /edit' do
      let(:user_a) { create(:user) }
      it 'ユーザー編集画面へ遷移する' do
        get edit_user_path(user_a)
        expect(response).to have_http_status(:success)
        expect(response.body).to include('ユーザー編集')
      end
    end

    describe 'GET /create' do
      subject(:action) { post users_path, params: { user: attributes } }

      context 'with valid attribute' do
        let(:attributes) { valid_attributes }

        it 'ユーザー新規登録に成功する' do
          expect { action }.to change(User, :count).by(1)
          expect(response).to redirect_to users_path
          follow_redirect!
          expect(response.body).to include('ユーザー一覧')
        end
      end

      context 'with invalid attribute' do
        let(:attributes) { invalid_attributes }

        it 'ユーザー新規登録に失敗する' do
          expect { subject }.to change(User, :count).by(0)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include('ユーザーの新規登録に失敗しました')
        end
      end
    end

    describe 'GET /update' do
      let!(:user_a) { create(:user, name: 'サンプル') }

      subject(:action) { patch user_path(user_a), params: { user: attributes } }

      context 'with valid attribute' do
        let(:attributes) { { name: 'テスト', password: 'password', password_confirmation: 'password' } }

        it 'ユーザー情報の更新に成功する' do
          expect { action }.to change { user_a.reload.name }.from(user_a.name).to('テスト')
          expect(response).to redirect_to users_path
          follow_redirect!
          expect(response.body).to include('ユーザー一覧')
        end
      end

      context 'with invalid attribute' do
        let(:attributes) { { name: '' } }

        it 'ユーザー情報の更新に失敗する' do
          expect { action }.not_to(change { user_a.reload.name })
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include('ユーザーの更新に失敗しました')
        end
      end
    end

    describe 'GET /destroy' do
      let!(:user_a) { create(:user) }

      subject(:action) { delete user_path(user_a) }
      it 'ユーザーが削除され、一覧に戻る' do
        expect { action }.to change(User, :count).by(-1)
        expect(response).to redirect_to(users_path)
        follow_redirect!
        expect(response.body).to include('ユーザー一覧')
      end
    end
  end

  describe 'with user ' do
    context 'when the user is not logged in' do
      describe 'GET /new' do
        it 'ユーザー新規作成画面へ遷移する' do
          get new_user_path
          expect(response).to have_http_status(:success)
          expect(response.body).to include('ユーザー新規作成')
        end
      end

      describe 'GET /create' do
        subject(:action) { post users_path, params: { user: attributes } }

        context 'with valid attribute' do
          let(:attributes) { valid_attributes }

          it 'ユーザー新規登録に成功する' do
            expect { action }.to change(User, :count).by(1)
            expect(response).to redirect_to root_path
            follow_redirect!
            expect(response.body).to include '<title>ホーム画面 | 専属ひしょ子ちゃん</title>'
          end
        end

        context 'with invalid attribute' do
          let(:attributes) { invalid_attributes }

          it 'ユーザー新規登録に失敗する' do
            expect { subject }.to change(User, :count).by(0)
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.body).to include('ユーザーの新規登録に失敗しました')
          end
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

      describe 'GET /show' do
        it 'ユーザー詳細画面へ遷移する' do
          get user_path(user)
          expect(response).to have_http_status(:success)
          expect(response.body).to include('ユーザー詳細')
        end
      end

      describe 'GET /edit' do
        it 'ユーザー編集画面へ遷移する' do
          get edit_user_path(user)
          expect(response).to have_http_status(:success)
          expect(response.body).to include('ユーザー編集')
        end
      end

      describe 'GET /update' do
        subject(:action) { patch user_path(user), params: { user: attributes } }

        context 'with valid attribute' do
          let(:attributes) { { name: 'テスト', password: 'password', password_confirmation: 'password' } }

          it 'ユーザー情報の更新に成功する' do
            expect { action }.to change { user.reload.name }.from(user.name).to('テスト')
            expect(response).to redirect_to root_path
            follow_redirect!
            expect(response.body).to include('ユーザー詳細')
          end
        end

        context 'with invalid attribute' do
          let(:attributes) { { name: '' } }

          it 'ユーザー情報の更新に失敗する' do
            expect { action }.not_to(change { user.reload.name })
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.body).to include('ユーザーの更新に失敗しました')
          end
        end
      end

      describe 'GET /destroy' do
        subject(:action) { delete user_path(user) }
        it ' ユーザーが削除され、ホーム画面へ遷移する' do
          expect { action }.to change(User, :count).by(-1)
          expect(response).to redirect_to root_path
          follow_redirect!
          expect(response.body).to include '<title>ホーム画面 | 専属ひしょ子ちゃん</title>'
        end
      end
    end
  end
end
