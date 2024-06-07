# frozen_string_literal: true

class ExpendituresController < ApplicationController
  before_action :set_expenditure, only: [:edit, :update, :destroy]
  before_action :authorize_expenditure

  def index
    @expenditures = policy_scope(Expenditure).order(created_at: :desc)
  end

  def new
    @expenditure = current_user.expenditures.new
  end

  def create
    @expenditure = current_user.expenditures.new(permitted_attributes(Expenditure))
    if @expenditure.save
      redirect_to expenditures_path
    else
      flash.now[:danger] = "#{Expenditure.model_name.human}#{t('create_failed')}"
      render :index, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @expenditure.update(permitted_attributes(@expenditure))
      flash[:success] = "#{Expenditure.model_name.human}#{t('update_success')}"
      redirect_to expenditures_path
    else
      flash.now[:danger] = "#{Expenditure.model_name.human}#{t('update_failed')}"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expenditure.destroy
    flash[:success] = "#{Expenditure.model_name.human}#{t('delete_success')}"
    redirect_to expenditures_path
  end

  private

  def set_expenditure
    @expenditure = Expenditure.find(params[:id])
  end

  def authorize_expenditure
    authorize @expenditure || Expenditure
  end
end
