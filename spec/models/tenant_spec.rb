# == Schema Information
#
# Table name: tenants
#
#  id         :integer          not null, primary key
#  industry   :integer          default("standing_bar"), not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Tenant, type: :model do
  let(:admin) { build(:admin) }
  let(:tenant) { build(:tenant) }

  describe 'validations' do
    describe 'name' do
      describe 'presence' do
        before do
          tenant.name = nil
          tenant.valid?
        end

        context 'with name is nil' do
          it { expect(tenant.errors.messages[:name]).to include('を入力してください') }
        end
      end

      describe 'uniqueness' do
        let(:tenant2) { create(:tenant) }

        before do
          tenant.name = tenant2.name
          tenant.valid?
        end

        context 'with name is already taken' do
          it { expect(tenant.errors.messages[:name]).to include('はすでに存在します') }
        end
      end
    end

    describe 'industry' do
      describe 'presence' do
        before do
          tenant.industry = nil
          tenant.valid?
        end

        context 'with industry is nil' do
          it { expect(tenant.errors.messages[:industry]).to include('を入力してください') }
        end
      end
    end
  end
end
