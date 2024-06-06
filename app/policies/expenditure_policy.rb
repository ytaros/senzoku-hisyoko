# frozen_string_literal: true

class ExpenditurePolicy < ApplicationPolicy
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

  def permitted_attributes
    [:user_id, :status, :expense_value, :recorded_at, :compiled_at]
  end

  class Scope < Scope
    def resolve
      scope.where(user_id: user.id) if user.common?
    end
  end
end
