# frozen_string_literal: true

class ReceiptPolicy < ApplicationPolicy
  def index?
    user.common?
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

  def permitted_attributes_for_create
    [:user_id, :status, :recorded_at]
  end

  def permitted_attributes_for_update
    [:food_value, :drink_value, :total_value, :user_id, :status, :compiled_at, :recorded_at]
  end

  class Scope < Scope
    def resolve
      scope.where(user_id: user.id) if user.common?
    end
  end
end
