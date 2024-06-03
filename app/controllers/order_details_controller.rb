class OrderDetailsController < ApplicationController
  before_action :authorize_order_detail

  def create
    @order_detail = OrderDetail.new(permitted_attributes(OrderDetail))

    if @order_detail.save
      redirect_to edit_receipt_path(@order_detail.receipt)
    else
      flash.now[:danger] = "#{OrderDetail.model_name.human}#{t('create_failed')}"
      render edit_receipt_path
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

end
