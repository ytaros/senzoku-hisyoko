# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReceiptPolicy, type: :policy do
  let(:user) { build(:user) }
  let(:receipt) { build(:receipt, :update_to_redord, user: user) }

  subject { described_class }

  permissions :index?, :show?, :update?, :destroy? do
    let(:user) { create(:user) }
    let(:user_a) { create(:user) }
    let(:receipt) { create(:receipt, :update_to_redord, user: user) }

    it { expect(described_class).to permit(user, receipt) }
    it { expect(described_class).not_to permit(user_a, receipt) }
  end

  permissions :create? do
    it { expect(described_class).to permit(user) }
  end

  permissions :permitted_attributes_for_create do
    it { expect(described_class.new(user, Receipt).permitted_attributes_for_create).to contain_exactly(:user_id, :status, :recorded_at) }
  end

  permissions :permitted_attributes_for_update do
    it { expect(described_class.new(user, Receipt).permitted_attributes_for_update).to contain_exactly(:food_value, :drink_value, :total_value, :user_id, :status, :compiled_at, :recorded_at) }
  end
end
