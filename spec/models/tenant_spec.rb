# == Schema Information
#
# Table name: tenants
#
#  id         :integer          not null, primary key
#  industry   :integer          default("standing_bar"), not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Tenant, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
