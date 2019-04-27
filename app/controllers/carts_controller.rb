class CartsController < ApplicationController
  include AppHelpers::Cart

  # before_action :check_login
  # authorize_resource

  def index
    @cart_items = get_list_of_items_in_cart
    # @cart_cost = calculate_cart_items_cost
  end

  def show
  end

  def add_to_cart
    add_item_to_cart(Item.find(params[:id]))
  end

end