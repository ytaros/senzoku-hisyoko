# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  remember_digest :string
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
  has_many :receipts, dependent: :destroy
  has_many :expenditures, dependent: :destroy

  attr_accessor :remember_token

  validates :name, presence: true, length: { maximum: 10 }
  validates :login_id, presence: true, uniqueness: true, length: { minimum: 8 }, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i, message: :login_id_format }
  validates :password, presence: true, length: { minimum: 8 }, confirmation: true, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i, message: :password_format }

  def admin?
    false
  end

  def common?
    true
  end

  # 渡された文字列のハッシュ値を返す
  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 記憶トークンをUserオブジェクトの仮想のremember_token属性に代入。ハッシュ化してremember_digest属性に保存。
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  # 引数として受け取ったトークンとDBのユーザの記憶ダイジェストと比較、同一ならtrueを返す。
  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザの記憶ダイジェストをnilにする
  def forget
    return unless remember_digest

    update_attribute(:remember_digest, nil)
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name login_id tenant_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[tenant]
  end

  def self.create_guest
    create!(name: 'ゲストユーザ', login_id: generate_secure_alphanumeric, password: generate_secure_alphanumeric, tenant_id: Tenant.find_by(name: 'ゲスト居酒屋').id)
  end

  def self.generate_secure_alphanumeric
    letters = ('a'..'z').to_a + ('A'..'Z').to_a
    digits = ('0'..'9').to_a
    (letters.sample(4) + digits.sample(4)).shuffle.join
  end
end
