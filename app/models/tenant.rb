# == Schema Information
#
# Table name: tenants
#
#  id         :integer          not null, primary key
#  industry   :integer          default(1), not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tenant < ApplicationRecord
  
end
