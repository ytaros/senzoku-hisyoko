# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  login_id        :string           not null
#  tenant_id       :integer          not null
#
# Indexes
#
#  index_users_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  tenant_id  (tenant_id => tenants.id)
#
class User < ApplicationRecord
  has_secure_password

  belongs_to :tenant

  validates :name, presence: true, length: { maximum: 10 }
  validates :login_id, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }, confirmation: true # 正規表現でパスワードの強度をチェックする
  validates :tenant_id, presence: true, on: :create

  def admin?
    false
  end
end
