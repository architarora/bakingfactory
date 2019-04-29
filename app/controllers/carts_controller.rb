class CartsController < ApplicationController
  include AppHelpers::Cart

  # before_action :check_login
  # authorize_resource

  def index
    @cart_items = get_list_of_items_in_cart.to_a
    @cart_items_names = get_list_of_items_in_cart.map{|a| Item.find(a.item_id)}
    # puts @cart_items
    # @cart_cost = calculate_cart_items_cost
  end

  def show
  end

  def add_to_cart
    add_item_to_cart(Item.find(params[:id]).id)
    redirect_to items_path, notice: "Item added to cart!"
  end

  def clear_all_cart
    clear_cart
    redirect_to carts_path, notice: "Items cleared from cart!"
  end

  def remove_item
    remove_item_from_cart(Item.find(params[:id]).id)
    redirect_to carts_path, notice: "Removed item from cart!"
  end

end