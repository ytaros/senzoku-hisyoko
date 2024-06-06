# frozen_string_literal: true

class ReceiptsController < ApplicationController
  before_action :set_receipt, only: [:edit, :update, :destroy]
  before_action :authorize_receipt
  before_action :set_total_values_by_genre, only: [:edit, :update]

  def index
    @receipts = policy_scope(Receipt)
    @receipt = current_user.receipts.new
  end

  def create
    @receipt = current_user.receipts.new(permitted_attributes(Receipt))
    if @receipt.save
      redirect_to edit_receipt_path(@receipt)
    else
      @receipts = policy_scope(Receipt)
      flash.now[:danger] = "#{Receipt.model_name.human}#{t('create_failed')}"
      render :index, status: :unprocessable_entity
    end
  end

  def edit
    @menus = policy_scope(Menu).order(:genre, price: :desc)
    @order_detail = OrderDetail.new
    @order_details = @receipt.order_details.includes(:menu)
  end


  def update
    @order_details = @receipt.order_details.includes(:menu)

    if @receipt.update(food_value: @food_value, drink_value: @drink_value)
      flash[:success] = "#{Receipt.model_name.human}#{t('update_success')}"
      redirect_to receipts_path
    else
      set_order_detail_and_menus
      flash.now[:danger] = "#{Receipt.model_name.human}#{t('update_failed')}"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @receipt.destroy
    flash[:success] = "#{Receipt.model_name.human}#{t('delete_success')}"
    redirect_to receipts_path
  end

  private

  def set_receipt
    @receipt = policy_scope(Receipt)&.find(params[:id])
  end

  def set_order_detail_and_menus
    @menus = policy_scope(Menu).order(:genre, price: :desc)
    @order_detail = OrderDetail.new(receipt: @receipt)
    @order_details = @receipt.order_details.includes(:menu)
  end

  def authorize_receipt
    authorize @receipt || Receipt
  end

  def set_total_values_by_genre
    totals_by_genre = OrderDetail.total_by_genre(@receipt)
    @food_value = totals_by_genre['food'] || 0
    @drink_value = totals_by_genre['drink'] || 0
  end
end
