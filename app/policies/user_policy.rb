# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    user.admin? || user.id == record.id
  end

  def create?
    index?
  end

  def update?
    show?
  end

  def destroy?
    index?
  end

  def permitted_attributes_for_create
    %i[name login_id tenant_id password password_confirmation]
  end

  def permitted_attributes_for_update
    %i[name login_id password password_confirmation]
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
