# frozen_string_literal: true

# Admin.create(
#   name: ENV['ADMIN_NAME'],
#   login_id: ENV['ADMIN_LOGIN_ID'],
#   password: ENV['ADMIN_PASSWORD'],
#   password_confirmation: ENV['ADMIN_PASSWORD']
# )

# ゲスト用テナント作成
Tenant.create(
  name: 'ゲスト居酒屋',
  industry: :tavern
)

# ゲスト用メニュー作成
Menu.create(
  genre: :food,
  category: '唐揚げ',
  price: 500,
  tenant_id: Tenant.find_by(name: 'ゲスト居酒屋').id
)

Menu.create(
  genre: :drink,
  category: '生ビール',
  price: 400,
  tenant_id: Tenant.find_by(name: 'ゲスト居酒屋').id
)
