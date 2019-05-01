class CartsController < ApplicationController
  include AppHelpers::Cart
  include AppHelpers::Shipping

  # before_action :check_login
  # authorize_resource

  def index
    @cart_items = get_list_of_items_in_cart.to_a
    @cart_items_names = get_list_of_items_in_cart.map{|a| Item.find(a.item_id)}
    @subtotal_cost = calculate_cart_items_cost
    @shipping_cost = calculate_cart_shipping
    @total_cost = @subtotal_cost + @shipping_cost
    # puts @cart_items
    # @cart_cost = calculate_cart_items_cost
  end

  def show
  end

  def add_to_cart
    add_item_to_cart(Item.find(params[:id]).id.to_s)
    redirect_to items_path, notice: "#{Item.find(params[:id]).name} added to cart!"
  end

  def clear_all_cart
    clear_cart
    redirect_to carts_path, notice: "Items cleared from cart!"
  end

  def remove_item
    remove_item_from_cart(Item.find(params[:id]).id.to_s)
    redirect_to carts_path, notice: "#{Item.find(params[:id]).name} removed from cart!"
  end

  def checkout
    redirect_to carts_path, notice: "Please complete the below form."
  end

end