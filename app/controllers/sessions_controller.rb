# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_after_action :verify_authorized

  def new; end

  def create
    user = User.find_by(login_id: params[:session][:login_id])
    if user&.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      flash[:success] = t('login_success')
      redirect_to root_path
    else
      flash.now[:danger] = t('login_failed')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = t('logout_success')
    redirect_to login_path, status: :see_other
  end
end
