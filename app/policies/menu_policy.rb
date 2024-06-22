# frozen_string_literal: true

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
    show?
  end

  def hide?
    show?
  end

  def permitted_attributes
    [:category, :price, :genre, :tenant_id]
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.active
      else
        scope.where(tenant_id: user.tenant_id).active
      end
    end
  end
end
