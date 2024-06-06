# == Schema Information
#
# Table name: expenditures
#
#  id            :integer          not null, primary key
#  compiled_at   :date
#  expense_value :integer          not null
#  recorded_at   :date
#  status        :string           default("0"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer          not null
#
class Expenditure < ApplicationRecord
end
