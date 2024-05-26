require 'rails_helper'

RSpec.describe MenuPolicy, type: :policy do
  subject { described_class }

  let(:admin) { build(:admin) }
  let(:tenant) { create(:tenant) }
  let(:tenant_a) { create(:tenant) }
  let(:user) { build(:user, tenant_id: tenant.id) }
  let(:menu) { build(:menu, tenant_id: tenant.id) }
  let(:menu_a) { build(:menu, tenant_id: tenant_a.id) }

  permissions :index? do
    it { expect(described_class).to permit(admin) }
    it { expect(described_class).to permit(user) }
  end

  permissions :create? do
    it { expect(described_class).not_to permit(admin) }
    it { expect(described_class).to permit(user) }
  end

  permissions :show?, :update?, :destroy? do
    it { expect(described_class).not_to permit(admin, menu) }
    it { expect(described_class).to permit(user, menu) }
    it { expect(described_class).not_to permit(user, menu_a) }
  end

  permissions :permitted_attributes do
    it { expect(described_class.new(admin, Menu).permitted_attributes).to contain_exactly(:category, :genre, :price, :tenant_id) }
    it { expect(described_class.new(user, Menu).permitted_attributes).to contain_exactly(:category, :genre, :price, :tenant_id) }
  end

  permissions :scope do
    let(:menu) { create(:menu, tenant_id: tenant.id) }
    let(:menu_a) { create(:menu, tenant_id: tenant_a.id) }
    it { expect(MenuPolicy::Scope.new(admin, Menu).resolve).to contain_exactly(menu, menu_a) }
    it { expect(MenuPolicy::Scope.new(user, Menu).resolve).to contain_exactly(menu) }
  end
end
