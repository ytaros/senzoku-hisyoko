# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TenantPolicy, type: :policy do
  let(:admin) { build(:admin) }
  let(:tenant) { build(:tenant) }

  subject { described_class }

  permissions :show? do
    it { expect(described_class).to permit(admin, tenant) }
  end

  permissions :create? do
    it { expect(described_class).to permit(admin) }
  end

  permissions :update? do
    it { expect(described_class).to permit(admin, tenant) }
  end

  permissions :destroy? do
    it { expect(described_class).to permit(admin, tenant) }
  end

  permissions :permitted_attributes do
    it { expect(described_class.new(admin, Tenant).permitted_attributes).to contain_exactly(:name, :industry) }
  end
end
