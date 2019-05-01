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
  	@previous_orders = current_user.customer.orders
  	@previous_items = current_user.customer.orders.map {|a| a.order_items.map {|l| l.item}}.last(10)
  	puts @previous_items
  end

  def baking_list
    @unshipped_orders_bread = OrderItem.all.unshipped.select{|a| a.item.category == "bread"}
    @unshipped_orders_bread = @unshipped_orders_bread.inject(Hash.new(0)){|h,k|; h[k.item.name] += 1;h}
    # @unshipped_orders_bread = Order.not_shipped
    @unshipped_orders_muffin = OrderItem.all.unshipped.select{|a| a.item.category == "muffins"}
    @unshipped_orders_muffin = @unshipped_orders_muffin.inject(Hash.new(0)){|h,k|; h[k.item.name] += 1;h}

    @unshipped_orders_pastry = OrderItem.all.unshipped.select{|a| a.item.category == "pastries"}
    @unshipped_orders_pastry = @unshipped_orders_pastry.inject(Hash.new(0)){|h,k|; h[k.item.name] += 1;h}

  end

end