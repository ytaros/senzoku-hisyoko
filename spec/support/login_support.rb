module LoginSupport
  def login(user)
    if user.is_a?(Admin)
      post admin_login_path, params: { admin_session: { login_id: user.login_id, password: user.password } }
    else
      post login_path, params: { session: { email: user.email, password: user.password } }
    end
  end
end