# frozen_string_literal: true

class TenantsController < ApplicationController
  before_action :set_tenant, only: %i[show edit update destroy]
  before_action :tenant_authorize

  def index
    @tenants = Tenant.all
  end

  def new
    @tenant = Tenant.new
  end

  def show; end

  def create
    @tenant = Tenant.new(permitted_attributes(Tenant))
    if @tenant.save
      flash[:success] = "#{Tenant.model_name.human}#{t('create_success')}"
      redirect_to tenants_path
    else
      flash.now[:danger] = "#{Tenant.model_name.human}#{t('create_failed')}"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @tenant.destroy
    flash[:success] = "#{Tenant.model_name.human}#{t('delete_success')}"
    redirect_to tenants_path
  end

  def edit; end

  def update
    if @tenant.update(permitted_attributes(Tenant))
      flash[:success] = "#{Tenant.model_name.human}#{t('update_success')}"
      redirect_to tenants_path
    else
      flash.now[:danger] = "#{Tenant.model_name.human}#{t('update_failed')}"
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
