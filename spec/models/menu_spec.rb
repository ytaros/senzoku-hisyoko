# == Schema Information
#
# Table name: menus
#
#  id         :integer          not null, primary key
#  category   :string           not null
#  ganre      :integer          not null
#  price      :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tenant_id  :integer          not null
#
# Indexes
#
#  index_menus_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  tenant_id  (tenant_id => tenants.id)
#
require 'rails_helper'

RSpec.describe Menu, type: :model do
  let(:tenant) { create(:tenant) }
  let(:menu) { build(:menu, tenant_id: tenant.id) }

  describe '#Validations' do
    describe 'category' do
      describe 'presence' do
        before do
          menu.category = nil
          menu.valid?
        end

        context 'with category is nil' do
          it { expect(menu.errors.messages[:category]).to include('を入力してください') }
        end
      end

      describe 'length' do
        before do
          menu.category = 'a' * 21
          menu.valid?
        end

        context 'with category is 21 characters' do
          it { expect(menu.errors.messages[:category]).to include('は20文字以内で入力してください') }
        end
      end
    end

    describe 'price' do
      describe 'presence' do
        before do
          menu.price = nil
          menu.valid?
        end

        context 'with price is nil' do
          it { expect(menu.errors.messages[:price]).to include('を入力してください') }
        end
      end

      describe 'numericality' do
        before do
          menu.price = 'a'
          menu.valid?
        end

        context 'with price is not a number' do
          it { expect(menu.errors.messages[:price]).to include('は数値で入力してください') }
        end
      end

      describe 'greater_than' do
        before do
          menu.price = 0
          menu.valid?
        end

        context 'with price is 0' do
          it { expect(menu.errors.messages[:price]).to include('は0より大きい値にしてください') }
        end
      end

      describe 'integer' do
        before do
          menu.price = 1.1
          menu.valid?
        end

        context 'with price is not an integer' do
          it { expect(menu.errors.messages[:price]).to include('は整数で入力してください') }
        end
      end
    end

    describe 'ganre' do
      describe 'presence' do
        before do
          menu.ganre = nil
          menu.valid?
        end

        context 'with ganre is nil' do
          it { expect(menu.errors.messages[:ganre]).to include('を入力してください') }
        end
      end
    end

    describe 'tenant_id' do
      describe 'presence' do
        before do
          menu.tenant_id = nil
          menu.valid?
        end

        context 'with tenant_id is nil' do
          it { expect(menu.errors.messages[:tenant_id]).to include('を入力してください') }
        end
      end
    end
  end
end

