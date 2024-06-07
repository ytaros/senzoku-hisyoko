# frozen_string_literal: true

class OrderDetailPolicy < ApplicationPolicy
  def create?
    user.common?
  end

  def destroy?
    create?
  end

  def permitted_attributes
    [:quantity, :menu_id, :receipt_id]
  end
end
