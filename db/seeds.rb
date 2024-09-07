# frozen_string_literal: true

Admin.create(
  name: ENV['ADMIN_NAME'],
  login_id: ENV['ADMIN_LOGIN_ID'],
  password: ENV['ADMIN_PASSWORD'],
  password_confirmation: ENV['ADMIN_PASSWORD']
)
