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

  permissions :permitted_attributes do
    it { expect(described_class.new(admin, User).permitted_attributes).to contain_exactly(:name, :login_id, :tenant_id, :password, :password_confirmation) }
    it { expect(described_class.new(user, User).permitted_attributes).to contain_exactly(:name, :login_id, :password, :tenant_id, :password_confirmation) }
  end

  permissions :scope do
    let(:tenant) { create(:tenant) }
    let(:user) { create(:user, tenant:) }
    let(:other_user) { create(:user, tenant:) }

    it { expect(UserPolicy::Scope.new(admin, User).resolve).to contain_exactly(user, other_user) }
    it { expect(UserPolicy::Scope.new(admin, User).resolve).to contain_exactly(user) }
  end
end
