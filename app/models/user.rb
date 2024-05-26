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

  attr_accessor :remember_token

  validates :name, presence: true, length: { maximum: 10 }
  validates :login_id, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }, confirmation: true # 正規表現でパスワードの強度をチェックする
  validates :tenant_id, presence: true, on: :create

  def admin?
    false
  end

  def common?
    true
  end

  # 渡された文字列のハッシュ値を返す
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
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

  # 引数として受け取ったトークンとDBのユーザーの記憶ダイジェストと比較、同一ならtrueを返す。
  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーの記憶ダイジェストをnilにする
  def forget
    return unless remember_digest
    update_attribute(:remember_digest, nil)
  end
end
