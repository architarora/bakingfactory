class SessionsController < ApplicationController
  include AppHelpers::Cart
  include AppHelpers::Baking
  def new
  end

  def show
  end
  
  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      session[:user_id] = user.id
      create_cart
      redirect_to home_path, notice: "Logged in!"
    else
      flash.now.alert = "Username and/or password is invalid"
      render "new"
    end
  end
  
  def destroy
    session[:user_id] = nil
    destroy_cart
    redirect_to home_path, notice: "Logged out!"
  end

  def baking_list
    # @unshipped_orders_bread = OrderItem.all.unshipped.select{|a| a.item.category == "bread"}
    # @unshipped_orders_bread = @unshipped_orders_bread.inject(Hash.new(0)){|h,k|; h[k.item.name] += 1;h}
    # # @unshipped_orders_bread = Order.not_shipped
    # @unshipped_orders_muffin = OrderItem.all.unshipped.select{|a| a.item.category == "muffins"}
    # @unshipped_orders_muffin = @unshipped_orders_muffin.inject(Hash.new(0)){|h,k|; h[k.item.name] += 1;h}

    # @unshipped_orders_pastry = OrderItem.all.unshipped.select{|a| a.item.category == "pastries"}
    # @unshipped_orders_pastry = @unshipped_orders_pastry.inject(Hash.new(0)){|h,k|; h[k.item.name] += 1;h}

    @unshipped_orders_bread = create_baking_list_for("bread")
    @unshipped_orders_muffin = create_baking_list_for("muffins")
    @unshipped_orders_pastry = create_baking_list_for("pastries")

  end

  def shipping_list
    @unshipped_items = OrderItem.all.unshipped.paginate(:page => params[:page]).per_page(10)
    @shipped_items = OrderItem.all.shipped.order(shipped_on: :desc).paginate(:page => params[:page]).per_page(10)
    @shipped_items_c = Order.all.map {|a| a.unshipped_items}
  end

  def mark_shipped
    @current_oi = OrderItem.find(params[:id])
    @current_oi.update(shipped_on,Date.today)
    redirect_to shipping_list_path, notice: "Marked as shipped!"
  end

  def mark_unshipped
    @current_oi = OrderItem.find(params[:id])
    @current_oi.update(@current_oi.shipped_on,nil)
    redirect_to shipping_list_path, notice: "Marked as unshipped!"
  end

end