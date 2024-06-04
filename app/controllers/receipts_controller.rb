# frozen_string_literal: true

class ReceiptsController < ApplicationController
  before_action :set_receipt, only: [:edit, :update, :destroy]
  before_action :authorize_receipt

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

  # リファクタリングする
  def edit
    @menus = policy_scope(Menu).order(:genre, price: :desc)
    @order_detail = OrderDetail.new(receipt: @receipt)
    @order_details = @receipt.order_details.includes(:menu)
  end
  # リファクタリングする
  # OrderDetailで作成されたオブジェクトからfood_value,drink_valueを取得して、それを元にReceiptのオブジェクトを作成する
  def update
    @order_details = @receipt.order_details.includes(:menu)
    food_value = OrderDetail.total_by_genre(@order_details, 'food')
    drink_value = OrderDetail.total_by_genre(@order_details, 'drink')

    if @receipt.update(food_value: food_value, drink_value: drink_value)
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
end
