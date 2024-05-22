require 'rails_helper'

RSpec.describe TenantPolicy, type: :policy do
  let(:admin) { build(:admin) }

  subject { described_class }

  permissions :show? do
    it{ expect(subject).to permit(admin) }
  end

  permissions :create? do
    it{ expect(subject).to permit(admin) }
  end

  permissions :update? do
    it{ expect(subject).to permit(admin) }
  end

  permissions :destroy? do
    it{ expect(subject).to permit(admin) }
  end
end
