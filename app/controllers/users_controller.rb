# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :logged_in_user, only: [:new, :create]
  before_action :user_authorize

  def index
    @q = policy_scope(User).ransack(params[:q])
    @pagy, @users = pagy(@q.result)
  end

  def show
    @tenant = @user.tenant
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(permitted_attributes(User))
    if @user.save
      flash[:success] = "#{User.model_name.human}#{t('create_success')}"
      redirect_to tenants_path
    else
      flash.now[:danger] = "#{User.model_name.human}#{t('create_failed')}"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update(permitted_attributes(@user))
      flash[:success] = "#{User.model_name.human}#{t('update_success')}"
      redirect_to current_user&.admin? ? tenants_path : root_path
    else
      flash.now[:danger] = "#{User.model_name.human}#{t('update_failed')}"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{User.model_name.human}#{t('delete_success')}"
    redirect_to tenants_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_authorize
    authorize @user || User
  end
end
