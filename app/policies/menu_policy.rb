class MenuPolicy < ApplicationPolicy
  def index?
    user.admin? || user.common?
  end

  def show?
    user.common? && user.tenant_id == record.tenant_id
  end

  def create?
    user.common?
  end

  def update?
    user.common? && user.tenant_id == record.tenant_id
  end

  def destroy?
    user.common? && user.tenant_id == record.tenant_id
  end


  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(tenant_id: user.tenant_id)
      end
    end
  end
end
