# == Schema Information
#
# Table name: admins
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  login_id        :string           not null
#
require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe 'validations' do
    let(:admin) { build(:admin) }

    describe 'name' do
      describe 'presence' do
        before do
          admin.name = nil
          admin.valid?
        end

        context 'with name is nil' do
          it { expect(admin.errors.messages[:name]).to include('を入力してください') }
        end
      end

      describe 'length' do
        before do
          admin.name = 'a' * 11
          admin.valid?
        end

        context 'with name is 11 characters' do
          it { expect(admin.errors.messages[:name]).to include('は10文字以内で入力してください') }
        end
      end
    end

    describe 'login_id' do
      describe 'presence' do
        before do
          admin.login_id = nil
          admin.valid?

        end
        context 'with login_id is nil' do
          it { expect(admin.errors.messages[:login_id]).to include('を入力してください') }
        end
      end

      describe 'uniqueness' do
        let(:admin2) { create(:admin) }
        before do
          admin.login_id = admin2.login_id
          admin.valid?
        end

        context 'with login_id is already taken' do
          it { expect(admin.errors.messages[:login_id]).to include('はすでに存在します') }
        end
      end
    end

    describe 'password' do
      describe 'presence' do
        before do
          admin.password = nil
          admin.valid?
        end

        context 'with password is nil' do
          it { expect(admin.errors.messages[:password]).to include('を入力してください') }
        end
      end

      describe 'length' do
        before do
          admin.password = 'a' * 7
          admin.valid?
        end

        context 'with password is 7 characters' do
          it { expect(admin.errors.messages[:password]).to include('は8文字以上で入力してください') }
        end
      end

      describe 'confirmation' do
        before do
          admin.password = '11111111'
          admin.password_confirmation = '22222222'
          admin.valid?
        end

        context 'with password_confirmation is different from password' do
          it { expect(admin.errors.messages[:password_confirmation]).to include('パスワードが一致しません') }
        end
      end
    end
  end

  describe 'Instance methods' do
    let(:admin) { build(:admin) }

    describe '#admin?' do
      it { expect(admin.admin?).to be_truthy }
    end

    describe '#common?' do
      it { expect(admin.common?).to be_falsey }
    end
  end
end
