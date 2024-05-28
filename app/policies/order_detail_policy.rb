# frozen_string_literal: true

class OrderDetailPolicy < ApplicationPolicy
  def create?
    user.common?
  end

  def destroy?
    user.common?
  end
end
