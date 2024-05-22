# frozen_string_literal: true

class AdminSessionsController < ApplicationController
  skip_after_action :verify_authorized

  def new; end

  def create
    user = Admin.find_by(login_id: params[:admin_session][:login_id])
    if user&.authenticate(params[:admin_session][:password])
      log_in user
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
    redirect_to admin_login_path, status: :see_other
  end
end
