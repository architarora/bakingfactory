class CustomersController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  # before_action :check_login
  authorize_resource
  
  def index
    @active_customers = Customer.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_customers = Customer.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @previous_orders = @customer.orders.chronological
  end

  def new
    @customer = Customer.new
    user = @customer.build_user
  end

  def edit
    # reformat phone w/ dashes when displayed for editing (preference; not required)
    @customer.phone = number_to_phone(@customer.phone)
  end

  def create
    @customer = Customer.new(customer_params)
    user = @customer.build_user
    user_hash = customer_params.to_h
    # @user = User.new(customer_params[:users_attributes])
    if current_user.nil?
      @customer.user.role = "customer"
      @customer.active = "true"
    end

    @customer.user.active = "true"
    @customer.user.username = user_hash['user_attributes']['username']
    @customer.user.password = user_hash['user_attributes']['password']
    @customer.user.password_confirmation = user_hash['user_attributes']['password_confirmation']
    # @customer.user.role = user_hash['user_attributes']['role']

    if @customer.save
        flash[:notice] = "Successfully created account. Please login below."
        redirect_to login_path
    else
        render action: 'new'
    end 
  end

  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: "#{@customer.proper_name} was revised in the system."
    else
      render action: 'edit', notice: "Please fix errors below."
    end
  end

   def admin_dashboard
    @returning_customers = Customer.all.select{|a| a.orders.size >1}.to_a.size
    @returning_customers_active = Customer.active.select{|a| a.orders.size >1}.to_a.size
    @all_orders = Order.all
    @all_items = Item.all
    @all_customers = Customer.all
    @all_oi = OrderItem.all
    @item_o = OrderItem.all.map{|a| Item.where(id: a.item)}
    @most_pop_items = OrderItem.all.group_by{|a| a.item}.map{|a,b| [b.size, a.name]}.sort.reverse.first(5)

    @total_revenue = Order.all.map{|a| a.grand_total}.inject(0){|sum,x| sum + x }
    @total_revenue_month = Order.all.where("date > ?", 1.month.ago).map{|a| a.grand_total}.inject(0){|sum,x| sum + x }
    @total_revenue_quarter = Order.all.where("date > ?", 4.months.ago).map{|a| a.grand_total}.inject(0){|sum,x| sum + x }
    @total_revenue_year = Order.all.where("date > ?", 1.year.ago).map{|a| a.grand_total}.inject(0){|sum,x| sum + x }
    @num_active_customers = Customer.active.to_a.count
    @num_inactive_customers = Customer.inactive.to_a.count
    @top_customers = Order.all.group_by{|a| a.customer}.map{|customer,rest| customer.proper_name}.last(5)
    @t_c = Customer.all.map{|a| a.orders.map{|m| m.grand_total}.inject(0){|sum,x| sum + x }}
    @new_tc = @t_c.sort.reverse.first(10)
    @avg_order = @t_c.inject{ |sum, el| sum + el }.to_f / @t_c.size
    @avg_items = OrderItem.all.to_a.size / Order.all.to_a.size
    
    @tester = Order.all.where("date < ?", 2.weeks.ago).map{|a| a.grand_total}
  end

  def cust_dashboard
    @previous_orders = current_user.customer.orders
    @previous_items = current_user.customer.orders.map {|a| a.order_items.map {|l| l.item}}.last(5)
    @best_sellers = Item.all.last(5)
  end

  private
  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :phone, :active, user_attributes: [:username, :password, :password_confirmation, :role])
  end

end