# frozen_string_literal: true

module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
    session[:user_class_name] = user.class.name
  end

  def current_user
    user_class_name = session[:user_class_name] || cookies.signed[:user_class_name]
    user_id = session[:user_id] || cookies.signed[:user_id]

    if user_class_name && user_id
      @current_user ||= find_user(user_class_name, user_id)
      if !session[:user_id] && @current_user&.authenticated?(:remember, cookies[:remember_token])
        login @current_user
      end
    end
    @current_user
  end


  # ユーザーとトークンを紐づけ（remember_digestカラムにトークンをハッシュ化して保存）CookieにユーザーIDとトークンを入れる
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent.signed[:user_class_name] = user.class.name
    cookies.permanent[:remember_token] = user.remember_token
  end

  # セッションの破棄とCookieの削除
  def forget(user)
    user.forget if user.class.name == 'User'
    cookies.delete(:user_id)
    cookies.delete(:user_class_name)
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

  private

  def find_user(user_class_name, user_id)
    if user_class_name == 'Admin'
      Admin.find_by(id: user_id)
    else
      User.find_by(id: user_id)
    end
  end
end
