# frozen_string_literal: true

class ReceiptPolicy < ApplicationPolicy
  def index?
    user.common? && user.id == record.user_id
  end

  def show?
    user.common? && user.id == record.user_id
  end

  def create?
    user.common?
  end

  def update?
    user.common? && user.id == record.user_id
  end

  def destroy?
    user.common? && user.id == record.user_id
  end

  def permitted_attributes
    [:food_value, :drink_value, :total_value, :user_id, :status, :compiled_at, :recorded_at]
  end
end
