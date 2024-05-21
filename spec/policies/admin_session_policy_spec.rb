require 'rails_helper'

RSpec.describe AdminSessionPolicy, type: :policy do
  let(:admin) { build(:admin) }

  subject { described_class }

  permissions :new? do
    it{ expect(subject).to permit(admin) }
  end

  permissions :create?, :destroy? do
    it{ expect(subject).to permit(admin) }
  end
end
