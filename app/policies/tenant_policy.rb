# frozen_string_literal: true

class TenantPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    index?
  end

  def create?
    index?
  end

  def update?
    index?
  end

  def destroy?
    index?
  end

  def permitted_attributes
    %i[name industry]
  end
end
