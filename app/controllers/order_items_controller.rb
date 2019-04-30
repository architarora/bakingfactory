class OrderItemsController < ApplicationController
  before_action :set_order_item, only: [:show, :destroy]
  # before_action :check_login
  # authorize_resource
  
   def mark_shipped
    @current_oi = OrderItem.find(params[:id])
    @current_oi.shipped_on = Date.today
    @current_oi.save
    redirect_to shipping_list_path, notice: "Marked as shipped!"
  end

  def mark_unshipped
    @current_oi = OrderItem.find(params[:id])
    @current_oi.shipped_on = nil
    @current_oi.save
    # @current_oi.update(:shipped_on,nil)
    redirect_to shipping_list_path, notice: "Marked as unshipped!"
  end
 
  
  private
  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end

  def order_item_params
    params.require(:order).permit(:item, :quantity, :shipped_on)
  end

end