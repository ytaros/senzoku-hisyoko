# == Schema Information
#
# Table name: admins
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  login_id        :string           not null
#
class Admin < ApplicationRecord
  has_secure_password
  validates :name, presence: true
  validates :login_id, presence: true
  validates :password, presence: true, length: { minimum: 8 }

  def admin?
    true
  end
end
