# frozen_string_literal: true

class MenusController < ApplicationController
  before_action :set_menu, only: [:show, :edit, :update, :destroy]
  before_action :authorize_menu

  def index
    menus = policy_scope(Menu).order(price: :desc)
    @food_menus = menus.select(&:food?)
    @drink_menus = menus.select(&:drink?)
  end

  def show; end

  def new
    @menu = current_tenant.menus.new
  end

  def create
    @menu = current_tenant.menus.new(permitted_attributes(Menu))
    if @menu.save
      flash[:success] = "#{Menu.model_name.human}#{t('create_success')}"
      redirect_to menus_path
    else
      flash.now[:danger] = "#{Menu.model_name.human}#{t('create_failed')}"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @menu.update(permitted_attributes(@menu))
      redirect_to menu_path(@menu)
    else
      flash.now[:danger] = "#{Menu.model_name.human}#{t('update_failed')}"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @menu.destroy
    flash[:success] = "#{Menu.model_name.human}#{t('delete_success')}"
    redirect_to menus_path
  end

  private

  def set_menu
    @menu = policy_scope(Menu).find(params[:id])
  end

  def authorize_menu
    authorize @menu || Menu
  end
end
