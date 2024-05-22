module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
    session[:user_class_name] = user.class.name
  end


  def current_user
    user_class_name = session[:user_class_name]
    user_id = session[:user_id]
    if (klass_name = user_class_name) && user_id
      @current_user ||= Admin.find_by(id: session[:user_id]) if klass_name == 'Admin'
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalse
  def logged_in?
    !current_user.nil?
  end

  # ログアウト
  def log_out
    session.delete(:user_id)
    session.delete(:user_class_name)
    @current_user = nil
  end
end
