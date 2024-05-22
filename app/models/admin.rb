# frozen_string_literal: true

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

  validates :name, presence: true, length: { maximum: 10 }
  validates :login_id, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }, confirmation: true

  def admin?
    true
  end

  def common?
    false
  end
end
