# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  remember_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  login_id        :string           not null
#  tenant_id       :integer          not null
#
# Indexes
#
#  index_users_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  tenant_id  (tenant_id => tenants.id)
#
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:tenant) { create(:tenant) }
  let(:user) { build(:user, tenant:) }

  describe 'validations' do
    describe 'name' do
      describe 'presence' do
        before do
          user.name = nil
          user.valid?
        end

        context 'with name is nil' do
          it { expect(user.errors.messages[:name]).to include('を入力してください') }
        end
      end

      describe 'length' do
        before do
          user.name = 'a' * 11
          user.valid?
        end

        context 'with name is 11 characters' do
          it { expect(user.errors.messages[:name]).to include('は10文字以内で入力してください') }
        end
      end
    end

    describe 'login_id' do
      describe 'presence' do
        before do
          user.login_id = nil
          user.valid?
        end
        context 'with login_id is nil' do
          it { expect(user.errors.messages[:login_id]).to include('を入力してください') }
        end
      end

      describe 'uniqueness' do
        let(:user2) { create(:user, tenant:) }
        before do
          user.login_id = user2.login_id
          user.valid?
        end
        context 'with login_id is already taken' do
          it { expect(user.errors.messages[:login_id]).to include('はすでに存在します') }
        end
      end

      describe 'length' do
        before do
          user.login_id = 'a' * 7
          user.valid?
        end
        context 'with login_id is 7 characters' do
          it { expect(user.errors.messages[:login_id]).to include('は8文字以上で入力してください') }
        end
      end

      describe 'format' do
        before do
          user.login_id = 'sampleid'
          user.valid?
        end
        context 'with login_id is not include alphabet and number' do
          it { expect(user.errors.messages[:login_id]).to include('は英数字混合である必要があります') }
        end
      end
    end

    describe 'password' do
      describe 'presence' do
        before do
          user.password = nil
          user.valid?
        end
        context 'with password is nil' do
          it { expect(user.errors.messages[:password]).to include('を入力してください') }
        end
      end

      describe 'length' do
        before do
          user.password = 'a' * 7
          user.valid?
        end
        context 'with password is 7 characters' do
          it { expect(user.errors.messages[:password]).to include('は8文字以上で入力してください') }
        end
      end

      describe 'confirmation' do
        before do
          user.password_confirmation = 'pass'
          user.valid?
        end
        context 'with password_confirmation is not match' do
          it { expect(user.errors.messages[:password_confirmation]).to include('パスワードが一致しません') }
        end
      end

      describe 'format' do
        before do
          user.password = 'password'
          user.valid?
        end
        context 'with password is not include alphabet and number' do
          it { expect(user.errors.messages[:password]).to include('は英数字混合である必要があります') }
        end
      end
    end
  end

  describe 'Instance methods' do
    describe 'admin?' do
      it { expect(user.admin?).to be_falsey }
    end

    describe 'common?' do
      it { expect(user.common?).to be_truthy }
    end
  end
end
