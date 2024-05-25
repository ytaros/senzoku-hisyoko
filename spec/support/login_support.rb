# frozen_string_literal: true

module LoginSupport
  def login(user)
    if user.is_a?(Admin)
      post admin_login_path, params: { admin_session: { login_id: user.login_id, password: user.password } }
    elsif user.is_a?(User)
      post login_path, params: { session: { login_id: user.login_id, password: user.password } }
    end

    redirect_to root_path
  end
end
