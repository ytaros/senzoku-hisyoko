# frozen_string_literal: true

AdminSessionPolicy = Struct.new(:user, :admin_session) do
  def new?
    true
  end

  def create?
    user.admin?
  end

  def destroy?
    user.admin?
  end
end
