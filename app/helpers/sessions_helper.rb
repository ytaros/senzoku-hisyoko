# frozen_string_literal: true

module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
    session[:user_class_name] = user.class.name
  end

  def current_user
    return @current_user if defined?(@current_user)

    user_class_name = session[:user_class_name]
    user_id = session[:user_id]
    return unless user_class_name && user_id

    case user_class_name
    when 'Admin'
      @current_user ||= Admin.find_by(id: session[:user_id])
    when 'User'
      if (user_id = cookies.signed[:user_id])
        user = User.find_by(id: user_id)
        if user&.authenticated?(cookies[:remember_token])
          log_in user
          @current_user = user
        end
      end
    end
  end

  # ユーザーとトークンを紐づけ（remember_digestカラムにトークンをハッシュ化して保存）CookieにユーザーIDとトークンを入れる
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # セッションの破棄とCookieの削除
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # ユーザーがログインしていればtrue、その他ならfalse
  def logged_in?
    !current_user.nil?
  end

  # ログアウト
  def log_out
    forget current_user
    session.delete(:user_id)
    session.delete(:user_class_name)
    @current_user = nil
  end
end
