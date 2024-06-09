# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FinancialSummaryPolicy, type: :policy do
  subject { described_class }

  let(:admin) { build(:admin) }
  let(:user) { build(:user) }

  permissions :index?, :show?, :compile? do
    it { expect(described_class).not_to permit(admin) }
    it { expect(described_class).to permit(user) }
  end
end
