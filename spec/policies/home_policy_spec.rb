# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomePolicy, type: :policy do
  let(:admin) { build(:admin) }

  subject { described_class }

  permissions :index? do
    it{ expect(subject).to permit(admin) }
  end
end
