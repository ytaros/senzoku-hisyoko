# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :logged_in_user, only: [:new, :create]
  before_action :user_authorize

  def index
    @users = policy_scope(User)
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(permitted_attributes(User))
    if @user.save
      log_in @user
      flash[:success] = "#{User.model_name.human}#{t('create_success')}"
      redirect_to root_path
    else
      Rails.logger.info @user.errors.full_messages.to_s
      flash.now[:danger] = "#{User.model_name.human}#{t('create_failed')}"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update(permitted_attributes(@user))
      flash[:success] = "#{User.model_name.human}#{t('update_success')}"
      redirect_to current_user&.admin? ? users_path : root_path
    else
      flash.now[:danger] = "#{User.model_name.human}#{t('update_failed')}"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{User.model_name.human}#{t('delete_success')}"
    redirect_to users_path
  end

  private

  def set_user
    @user = policy_scope(User).find_by(params[:id])
  end

  def user_authorize
    authorize @user || User
  end
end
