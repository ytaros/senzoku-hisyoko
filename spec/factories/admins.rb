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
FactoryBot.define do
  factory :admin do
    name { 'admin' }
    login_id { 'superadmin' }
    password { 'password' }
  end
end
