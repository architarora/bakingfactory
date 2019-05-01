class OrdersController < ApplicationController
  include AppHelpers::Cart
  include AppHelpers::Shipping

  before_action :set_order, only: [:show, :destroy]
  before_action :check_login
  authorize_resource
  
  def index
    if current_user.role?(:customer)
    @all_orders = current_user.customer.orders.chronological.paginate(:page => params[:page]).per_page(10)
    else
      @all_orders = Order.chronological.paginate(:page => params[:page]).per_page(10)
    end
  end

  def show
    @previous_orders = @order.customer.orders.chronological.to_a
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.date = Date.current
    @order.expiration_year = @order.expiration_year.to_i
    @order.expiration_month = @order.expiration_month.to_i
    if current_user.role?(:customer)
      @order.customer_id = current_user.customer.id
    end
    if @order.save
      @order.grand_total = calculate_cart_items_cost() + calculate_cart_shipping()
      @order.pay
      save_each_item_in_cart(@order)
      clear_cart
      redirect_to @order, notice: "Thank you for ordering from the Baking Factory."
    else
      render action: 'order_cust'
      end
  end

  def order_cust
    @order = Order.new
  end

  def baking_list
    @unshipped_orders = OrderItems.unshipped
  end
  
  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:address_id, :customer_id, :grand_total, :date, :credit_card_number, :expiration_year, :expiration_month)
  end

end