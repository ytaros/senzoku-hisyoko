# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    user.admin? || (user.common? && user.id == record.id)
  end

  def create?
    user.nil?
  end

  def update?
    user.admin? || (user.common? && user.id == record.id)
  end

  def destroy?
    user.admin?
  end

  def permitted_attributes_for_create
    %i[name login_id tenant_id password password_confirmation]
  end

  def permitted_attributes_for_update
    %i[name login_id password password_confirmation]
  end

  class Scope < Scope
    def resolve
      user.admin? ? scope.all : scope.where(id: user.id)
    end
  end
end
