# frozen_string_literal: true

FactoryBot.define do
  factory :admin do
    name { 'admin' }
    login_id { 'superadmin' }
    password { 'password' }
  end
end
