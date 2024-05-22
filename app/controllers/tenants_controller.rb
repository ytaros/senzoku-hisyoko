# frozen_string_literal: true

class TenantsController < ApplicationController
  before_action :set_tenant, only: %i[show edit update destroy]
  before_action :tenant_authorize

  def index
    @tenants = Tenant.all
  end

  def new; end

  def show; end

  def create
    @tenant = Tenant.new(permitted_attributes(Tenant))
    if @tenant.save
      flash[:success] = '成功'
      redirect_to tenants_path
    else
      flash.now[:danger] = '失敗'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @tenant.destroy
    flash[:success] = '成功'
    redirect_to tenants_path
  end

  def edit; end

  def update
    if @tenant.update(permitted_attributes(Tenant))
      flash[:success] = '成功'
      redirect_to tenants_path
    else
      flash.now[:danger] = '失敗'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_tenant
    @tenant = Tenant.find(params[:id])
  end

  def tenant_authorize
    authorize Tenant
  end
end
