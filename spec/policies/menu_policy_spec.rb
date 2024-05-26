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
end
