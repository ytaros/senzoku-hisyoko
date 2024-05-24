require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  let(:user) { build(:user) }
  let(:admin) { build(:admin) }

  subject { described_class }

  permissions :index? do
    it { expect(described_class).to permit(admin) }
    it { expect(described_class).not_to permit(user) }
  end

  permissions :show?, :update?, :destroy? do
    let(:tenant) { create(:tenant) }
    let(:user) { create(:user ,tenant:) }
    let(:other_user) { create(:user, tenant:) }
    it { expect(described_class).to permit(admin, user) }
    it { expect(described_class).to permit(user, user) }
    it { expect(described_class).not_to permit(user, other_user) }
  end

  permissions :create? do
    it { expect(described_class).to permit(admin) }
    it { expect(described_class).to permit(user) }
  end
end
