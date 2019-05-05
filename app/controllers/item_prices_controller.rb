  class ItemPricesController < ApplicationController
  before_action :check_login
  authorize_resource

  def item_price_admin
    @item_price = ItemPrice.new
    @item = Item.find(params[:item_id])
  end

  def create
    @item_price = ItemPrice.new(item_price_params)
    @item_price.start_date = Date.current
    if @item_price.save
      redirect_to item_path(@item_price.item), notice: "Successfully updated item price."
    else
      @item = Item.find(params[:item_price][:item_id])
      render action: 'item_price_admin', locals: { item: @item }
    end
  end

  private

  def item_price_params
    params.require(:item_price).permit(:item_id, :price, :start_date, :end_date)
  end

end