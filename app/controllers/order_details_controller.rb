class OrderDetailsController < ApplicationController
  before_action :authorize_order_detail

  def create
    @order_detail = OrderDetail.new(permitted_attributes(OrderDetail))

    if @order_detail.save
      flash[:success] = "#{OrderDetail.model_name.human}#{t('create_success')}"
    else
      flash[:danger] = "#{OrderDetail.model_name.human}#{t('create_failed')}"
      Rails.logger.error(@order_detail.errors.full_messages)
    end
    redirect_to edit_receipt_path(@order_detail.receipt)
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

end
