# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenditurePolicy, type: :policy do
  let(:user) { build(:user) }
  let(:expenditure) { build(:expenditure, user: user) }

  subject { described_class }

  permissions :update?, :destroy? do
    let(:user) { create(:user) }
    let(:user_a) { create(:user) }
    let(:expenditure) { create(:expenditure, user: user) }

    it { expect(described_class).to permit(user, expenditure) }
    it { expect(described_class).not_to permit(user_a, expenditure) }
  end

  permissions :index?, :create? do
    it { expect(described_class).to permit(user) }
  end

  permissions :permitted_attributes do
    it { expect(described_class.new(user, Expenditure).permitted_attributes).to contain_exactly(:user_id, :status, :expense_value, :recorded_at, :compiled_at) }
  end

  permissions :scope do
    let(:tenant) { create(:tenant) }
    let(:user) { create(:user, tenant:) }
    let(:other_user) { create(:user, tenant:) }
    let(:expenditure) { create(:expenditure, user: user) }

    it { expect(ExpenditurePolicy::Scope.new(user, Expenditure).resolve).to contain_exactly(expenditure) }
    it { expect(ExpenditurePolicy::Scope.new(other_user, Expenditure).resolve).not_to contain_exactly(expenditure) }
  end
end
