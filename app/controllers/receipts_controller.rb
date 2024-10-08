# frozen_string_literal: true

class ReceiptsController < ApplicationController
  before_action :set_receipt, only: [:edit, :update, :destroy, :destroy_unload]
  before_action :authorize_receipt
  before_action :set_total_values_by_genre, only: [:edit, :update]

  def index
    @q = policy_scope(Receipt).ransack(params[:q])
    @pagy, @receipts = pagy(@q.result.order(created_at: :desc))
    @receipt = current_user.receipts.new
  end

  def create
    @receipt = current_user.receipts.new(permitted_attributes(Receipt))
    if @receipt.save
      redirect_to edit_receipt_path(@receipt)
    else
      flash[:danger] = "#{Receipt.model_name.human}#{t('create_failed')}"
      redirect_to receipts_path
    end
  end

  def edit
    @menus = policy_scope(Menu).order(:genre, price: :desc)
    @order_detail = OrderDetail.new
    @order_details = @receipt.order_details.includes(:menu)
  end

  def update
    @order_details = @receipt.order_details.includes(:menu)

    if @receipt.update(food_value: @food_value, drink_value: @drink_value, status: :unrecorded)
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

  def destroy_unload
    return if @receipt.unrecorded? || @receipt.recorded?

    @receipt.destroy
    head :no_content
  end

  private

  def set_receipt
    @receipt = Receipt.find(params[:id])
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
