require 'rails_helper'

RSpec.describe OrderDetailPolicy, type: :policy do
  let(:user) { build(:user) }
  let(:admin) { build(:admin) }
  let(:menu) { create(:menu) }
  let(:receipt) { create(:receipt) }
  let(:order_detail) { build(:order_detail, menu:, receipt:) }

  subject { described_class }

  permissions :create?, :destroy? do
    it { expect(described_class).not_to permit(admin, order_detail) }
    it { expect(described_class).to permit(user, order_detail) }
  end
end
