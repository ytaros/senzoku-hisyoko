class UsersController < ApplicationController
  before_action :set_user, only: [:show ,:edit, :update, :destroy]
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
      flash[:success] = "#{User.model_name.human}#{t('create_success')}"
      redirect_to users_path
    else
      Rails.logger.info "#{@user.errors.full_messages}"
      flash.now[:danger] = "#{User.model_name.human}#{t('create_failed')}"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update(permitted_attributes(User))
      flash[:success] = "#{User.model_name.human}#{t('updated_success')}"
      redirect_to users_path
    else
      flash.now[:danger] = "#{User.model_name.human}#{t('updated_failed')}"
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
    authorize User || @user
  end
end
