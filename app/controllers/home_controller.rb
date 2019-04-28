class HomeController < ApplicationController

  def home
  end

  def about
  end

  def privacy
  end

  def contact
  end

  def search
  	redirect_back(fallback_location: home_path) if params[:query].blank?
    @query = params[:query]
    @customers = Customer.search(@query)
    @items = Item.search(@query)
    @total_hits = @customers.size + @items.size
  end

  def admin_dashboard
  	@all_orders = Order.all
  	@all_items = Item.all
  	@all_customers = Customer.all
  	@all_oi = OrderItem.all
  end

  def cust_dashboard
  	@orders_cust = current_user.customer.orders
  	@previous_items = @orders_cust.
  end

end