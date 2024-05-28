class OrderDetailPolicy < ApplicationPolicy
  def create?
    user.common?
  end

  def destroy?
    user.common?
  end
end
