# frozen_string_literal: true

class OrderDetailsController < ApplicationController
  before_action :authorize_order_detail

  def create
    @order_detail = OrderDetail.new(permitted_attributes(OrderDetail))

    if @order_detail.save
      redirect_to edit_receipt_path(@order_detail.receipt)
    else
      # 非同期でエラーが発生した時の処理を追加
      redirect_to edit_receipt_path(@order_detail.receipt)
    end
  end

  def destroy
    @order_detail = OrderDetail.find(params[:id])
    @order_detail.destroy
    redirect_to edit_receipt_path(@order_detail.receipt)
  end

  private

  def authorize_order_detail
    authorize OrderDetail
  end

  def set_receipt_and_menus
    @receipt = policy_scope(Receipt)&.find(params[:id])
    @menus = policy_scope(Menu).order(:genre, price: :desc)
  end
end
