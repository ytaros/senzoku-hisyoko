class UserPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    user.admin? || user.id == record.id
  end

  def create?
    true
  end

  def update?
    user.admin? || user.id == record.id
  end

  def destroy?
    user.admin? || user.id == record.id
  end

  def permitted_attributes
    [:name, :login_id, :tenant_id, :password, :password_confirmation]
  end

  class Scope < Scope
    def resolve
      user.admin? ? scope.all : scope.where(user_id: user.id)
    end
  end
end
