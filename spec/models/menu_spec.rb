# frozen_string_literal: true

# == Schema Information
#
# Table name: menus
#
#  id         :integer          not null, primary key
#  category   :string           not null
#  genre      :integer          not null
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

        context 'with greater_than_or_equal_to' do
          before do
            menu.price = 0
            menu.valid?
          end

          it { expect(menu.errors.messages[:price]).to include('は1以上の値にしてください') }
        end

        context 'with less_than_or_equal_to' do
          before do
            menu.price = 100_000
            menu.valid?
          end

          it { expect(menu.errors.messages[:price]).to include('は99999以下の値にしてください') }
        end
      end

      context 'with price is not an integer' do
        before do
          menu.price = 1.1
          menu.valid?
        end

        it { expect(menu.errors.messages[:price]).to include('は整数で入力してください') }
      end
    end

    describe 'genre' do
      describe 'presence' do
        before do
          menu.genre = nil
          menu.valid?
        end

        context 'with genre is nil' do
          it { expect(menu.errors.messages[:genre]).to include('を入力してください') }
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

  describe 'Instance methods' do
    describe '#formatted_name' do
      it 'カテゴリと価格を結合した文字列を返す' do
        expect(menu.formatted_name).to eq("#{menu.category}:#{menu.price}""#{I18n.t('yen')}")
      end
    end
  end
end
